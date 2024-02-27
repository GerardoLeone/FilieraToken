// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MilkHubInventoryStorage {

     // Address of Organization che gestisce gli utenti
    address private  MilkHubOrg;

    constructor(){
        MilkHubOrg = msg.sender;
    }

    struct MilkBatch {
        uint256 id;
        string scadenza;
        uint256 quantity; 
        uint256 price; // Prezzo di vendita per un Litro di  ( Partita di Latte )
    }

            /// MilkHub -> Lista Prodotti 
    mapping(address => mapping(uint256 => MilkBatch)) private milkBatches;

    uint256[] milkBatchIdList;

//----------------------------------------------------------------- Business Logic ------------------------------------------------------------------------------------------------//


    // Add function to add CheesePiece
    function addMilkBatch(address walletMilkHub, string memory _scadenza, uint256 _quantity, uint256 _price) external returns (uint256,string memory, uint256, uint256) {
        
        // Generazione dell'ID 
        uint256 _id = uint256(keccak256(abi.encodePacked(
            _scadenza,
            _quantity,
            _price,
            walletMilkHub,
            block.timestamp
        )));

        //Crea una nuova Partita di Latte
        MilkBatch memory milkBatch = MilkBatch({
            id: _id,
            scadenza: _scadenza,
            quantity: _quantity,
            price: _price
        });

        // Inserisco L'id nell'Array 
        milkBatchIdList.push(_id);

        //Inserisce la nuova Partita di Latte nella lista milkBatches
        milkBatches[walletMilkHub][_id] = milkBatch;
        
        return (
                milkBatches[walletMilkHub][_id].id,
                milkBatches[walletMilkHub][_id].scadenza,
                milkBatches[walletMilkHub][_id].quantity,
                milkBatches[walletMilkHub][_id].price
              );
    }

    // Ritorna un MilkBatch 
    function getMilkBatch(address walletMilkHub, uint256 _id) external view returns (uint256, string memory, uint256, uint256) {

        MilkBatch memory milkBatch = milkBatches[walletMilkHub][_id];

        return (milkBatch.id, milkBatch.scadenza, milkBatch.quantity, milkBatch.price);

    }

    // Delete Cheese piece 
    // We can delete a cheese piece with -> address of Consumer and id of CheesePiece
    function deleteMilkBatch(address walletMilkHub, uint256 _id) external returns(bool value) {

        // Delete piece of Cheese
        delete milkBatches[walletMilkHub][_id];

        
        // Check CheesePiece in the mapping 
        if(milkBatches[walletMilkHub][_id].id  == 0 && deleteMilkBatchIdFromList(_id)){
            return true;
        }else {
            return false;
        }
    }

    function getMilkBatchListByMilkHub(address walletMilkHub) external view  returns (MilkBatch[] memory){
        MilkBatch [ ] memory  milkBatchList  = new MilkBatch[](milkBatchIdList.length);

        for (uint256 i=0; i<milkBatchIdList.length; i++){

                uint256 _id = milkBatchIdList[i];
                if(milkBatches[walletMilkHub][_id].id != 0){
                    // Esiste e questo è il MilkBatch dell'Utente 
                    MilkBatch storage new_milkbatch = milkBatches[walletMilkHub][_id];
                    milkBatchList[i] = new_milkbatch;
                } 
        }
        return milkBatchList;
    }


    function getAllMilkBatchList(address[] memory milkHubListaddress)external view returns (MilkBatch[]memory){
        
        MilkBatch [ ] memory  milkBatchList  = new MilkBatch[](milkBatchIdList.length);
        
        uint256 t = 0; 

        for(uint256 i = 0; i<milkHubListaddress.length; i++){
            
            MilkBatch [ ] memory milkBatchListFromUser = this.getMilkBatchListByMilkHub(milkHubListaddress[i]);
            
            for(uint256 j=0; j< milkBatchListFromUser.length; j++){
                MilkBatch memory new_milkbatch = milkBatchListFromUser[j];
                milkBatchList[t] = new_milkbatch;
                t = t+1;
            }
        }
        return milkBatchList;

    }

    
    function checkProduct(address ownerMilkBatch, uint256 _id_MilkBatch, uint256 quantityToBuy) external view  returns (bool){

            require(milkBatches[ownerMilkBatch][_id_MilkBatch].id == _id_MilkBatch, "Product non presente!");

            MilkBatch storage milkBatchObj = milkBatches[ownerMilkBatch][_id_MilkBatch];
            
            require(milkBatchObj.quantity >= quantityToBuy, "Quantity not Valid!");
            return true;
    }

    /**
        - Funzione isMilkBatchPresent() funzione per verificare che il MilkBatch è presente 
        - Verifica tramite _id e address del walletMilkHub se il Prodotto è presente 
        - ritorna TRUE se il confronto è vero 
        - ritorna FALSE se non è presente 
    */
    function isMilkBatchPresent(address walletMilkHub, uint256 _id)external view returns(bool){
        require( _id !=0 && _id>0,"ID MilkBatch Not Valid!");

        return milkBatches[walletMilkHub][_id].id == _id;
    }

//---------------------------------------------------------- Get Function ----------------------------------------------------------------------//   

    function getExpirationDate(address walletMilkHub, uint256 _id) external view returns(string memory) {

        MilkBatch memory milkBatch = milkBatches[walletMilkHub][_id];
        return milkBatch.scadenza;        
    }

    function getQuantity(address walletMilkHub, uint256 _id) external view returns(uint256) {

        MilkBatch memory milkBatch = milkBatches[walletMilkHub][_id];

        return milkBatch.quantity;        
    }

    function getPrice(address walletMilkHub, uint256 _id) external view returns(uint256) {

        MilkBatch memory milkBatch = milkBatches[walletMilkHub][_id];
        
        return milkBatch.price;        
    }

    function getLenghtList() internal view returns(uint256){
       return milkBatchIdList.length;
    }

//---------------------------------------------------------- Delete Function ----------------------------------------------------------------------//   

    function deleteMilkBatchIdFromList(uint256 _id)internal returns (bool) {
        for(uint256 i=0; ; i++){
            if(milkBatchIdList[i] == _id){
                delete  milkBatchIdList[i];
                return true;
            }
        }
        return false;
    }

// ------------------------------------------------------------ Set Function ------------------------------------------------------------------//

    // - Funzione updateMilkBatchQuantity() aggiorna la quantità del MilkBatch 
    function updateQuantity(address walletMilkHub, uint256 _id, uint256 _newQuantity) external  {
        
        milkBatches[walletMilkHub][_id].quantity = _newQuantity;
    }

}