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

    
    mapping(address => mapping(uint256 => MilkBatch)) private milkBatches;

//----------------------------------------------------------------- Business Logic ------------------------------------------------------------------------------------------------//



    // Add function to add CheesePiece
    function addMilkBatch(address walletMilkHub, string memory _scadenza, uint256 _quantity, uint256 _price) external returns (uint256,string memory, uint256, uint256) {
        // Generazione dell'ID 
        uint256 _id = uint256(keccak256(abi.encodePacked(
            _scadenza,
            _quantity,
            _price,
            walletMilkHub
        )));

        MilkBatch storage milkbatchControl = milkBatches[walletMilkHub][_id];
        require( milkbatchControl.id == 0, "Pezzo di Formaggio gia' Presente");

        //Crea una nuova Partita di Latte
        MilkBatch memory milkBatch = MilkBatch({
            id: _id,
            scadenza: _scadenza,
            quantity: _quantity,
            price: _price
        });

        //Inserisce la nuova Partita di Latte nella lista milkBatches
        milkBatches[walletMilkHub][_id] = milkBatch;
        
        return (milkBatches[walletMilkHub][_id].id, milkBatches[walletMilkHub][_id].scadenza, milkBatches[walletMilkHub][_id].quantity,milkBatches[walletMilkHub][_id].price);
    }

    // Ritorna un MilkBatch 
    function getMilkBatch(address walletMilkHub, uint256 _id) external view returns (uint256, string memory, uint256, uint256) {

        MilkBatch memory milkBatch = milkBatches[walletMilkHub][_id];

        return (milkBatch.id, milkBatch.scadenza, milkBatch.quantity, milkBatch.price);

    }

    // Delete Cheese piece 
    // We can delete a cheese piece with -> address of Consumer and id of CheesePiece
    function deleteMilkBatch(address walletMilkHub, uint256 _id) external returns(bool value) {

        uint256 lastIdMilkBatch = uint256(keccak256(abi.encodePacked(
            milkBatches[walletMilkHub][_id].scadenza,
            milkBatches[walletMilkHub][_id].quantity,
            milkBatches[walletMilkHub][_id].price,
            walletMilkHub
        )));

        require(milkBatches[walletMilkHub][_id].id == lastIdMilkBatch, "Utente non Autorizzato!");
        // Delete piece of Cheese
        delete milkBatches[walletMilkHub][_id];
        // Check CheesePiece in the mapping 
        if(milkBatches[walletMilkHub][_id].id  == 0){
            return true;
        }else {
            return false;
        }
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


// ------------------------------------------------------------ Set Function ------------------------------------------------------------------//

    // - Funzione updateMilkBatchQuantity() aggiorna la quantità del MilkBatch 
    function updateQuantity(address walletMilkHub, uint256 _id, uint256 _newQuantity) external  {
        
        milkBatches[walletMilkHub][_id].quantity = _newQuantity;
    }


}