// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CheeseProducerInventoryStorage {

    // Address of Organization che gestisce gli utenti
    address private cheeseProducerOrg;

    constructor() {
        cheeseProducerOrg = msg.sender;
    }

    struct Cheese {
        uint256 id; // Cheese ID 
        string dop;
        uint256 price;
        uint256 quantity;
    }

    mapping(address => mapping(uint256 => Cheese)) private cheeseBlocks;

    uint256 [] private cheeseBlockListId;

// --------------------------------------------------- Business Function --------------------------------------------------------------------------------------//



    function addCheeseBlock(
            address walletCheeseProducer,
            uint256 _id_MilkBatchAcquistato,
            string memory _dop,
            uint256 _price,
            uint256 _quantity
        ) external returns (uint256 , string memory , uint256 , uint256 ){

        uint256 _id = uint256(keccak256(abi.encodePacked(
            _id_MilkBatchAcquistato,
            _dop,
            _price,
            _quantity,
            walletCheeseProducer,
            block.timestamp
        )));


        // Crea un nuovo Blocco di formaggio
        Cheese memory cheeseBlock = Cheese({
            id: _id,
            dop: _dop,
            price: _price,
            quantity: _quantity
        });

        // Inserisci l'id all'interno della Lista 
        cheeseBlockListId.push(_id);

        // Inserisce il nuovo Blocco di formaggio nella lista cheeseBlocks
        cheeseBlocks[walletCheeseProducer][_id] = cheeseBlock;

        return (cheeseBlock.id,cheeseBlock.dop,cheeseBlock.price,cheeseBlock.quantity);
    }

    function getCheeseBlock(address walletCheeseProducer, uint256 _id) external view returns (uint256, string memory, uint256, uint256) {

        Cheese memory cheeseBlock = cheeseBlocks[walletCheeseProducer][_id];

        return (cheeseBlock.id, cheeseBlock.dop, cheeseBlock.price, cheeseBlock.quantity);
    }

    // Elimina il CheeseBlock 
    function deleteCheeseBlock(address walletCheeseProducer, uint256 _id) external returns(bool value) {

        delete cheeseBlocks[walletCheeseProducer][_id];
        // Check CheesePiece in the mapping 
        if(cheeseBlocks[walletCheeseProducer][_id].id  == 0 && deleteCheeseBlockIdFromList(_id)){
            return true;
        }else {
            return false;
        }
    }


    // Verifica che il CheeseBlock è già presente 
    function isCheeseBlockPresent(address walletCheeseProducer,uint256 _id_CheeseBlock) external view returns(bool){
        
        require( _id_CheeseBlock !=0 && _id_CheeseBlock>0, "ID MilkBatch Not Valid!");

        return cheeseBlocks[walletCheeseProducer][_id_CheeseBlock].id == _id_CheeseBlock;
    }


    function getCheeseBlockByCheeseProducer(address walletCheeseProducer)external view returns (Cheese[]memory){
        Cheese [ ] memory  cheeseBlockList  = new Cheese[](cheeseBlockListId.length);
        for (uint256 i=0; i<cheeseBlockListId.length; i++){

                uint256 _id = cheeseBlockListId[i];
                if(cheeseBlocks[walletCheeseProducer][_id].id != 0){
                    // Esiste e questo è il MilkBatch dell'Utente 
                    Cheese storage new_cheese = cheeseBlocks[walletCheeseProducer][_id];
                    cheeseBlockList[i] = new_cheese;
                } 
        }
        return cheeseBlockList;
    }

    function getAllCheeseBlockList(address[] memory cheeseProducerListAddress)external view returns (Cheese[]memory){
        
        Cheese [ ] memory  cheeseBlockList  = new Cheese[](cheeseBlockListId.length);
        
        uint256 t = 0; 

        for(uint256 i = 0; i<cheeseProducerListAddress.length; i++){
            
            Cheese [ ] memory cheeseBlockListFromUser = this.getCheeseBlockByCheeseProducer(cheeseProducerListAddress[i]);
            
            for(uint256 j=0; j< cheeseBlockListFromUser.length; j++){
                Cheese memory new_cheese = cheeseBlockListFromUser[j];
                cheeseBlockList[t] = new_cheese;
                t = t+1;
            }
        }
        return cheeseBlockList;

    }

    

// --------------------------------------------------- Get Function --------------------------------------------------------------------------------------//
    
    function getDop(address walletCheeseProducer, uint256 _id) external view returns(string memory) {

        Cheese memory cheeseBlock = cheeseBlocks[walletCheeseProducer][_id];
        return cheeseBlock.dop;
    }

    function getPrice(address walletCheeseProducer, uint256 _id) external view returns(uint256) {

        Cheese memory cheeseBlock = cheeseBlocks[walletCheeseProducer][_id];
        return cheeseBlock.price;
    }

    function getQuantity(address walletCheeseProducer, uint256 _id) external view returns(uint256) {

        Cheese memory cheeseBlock = cheeseBlocks[walletCheeseProducer][_id];
        return cheeseBlock.quantity;
    }

// --------------------------------------------------- Set Function --------------------------------------------------------------------------------------//


    // - Funzione updateCheeseBlockQuantity() aggiorna la quantità del CheeseBlock 
    function updateCheeseBlockQuantity(
        address walletCheeseProducer,
        uint256 _id_Cheese,
        uint256 _newQuantity
    ) external  {
        
        // Controllo sulla quantita' 
        require(_newQuantity<=cheeseBlocks[walletCheeseProducer][_id_Cheese].quantity,"Controllo della Quantita' da utilizzare non andata a buon fine!");

        cheeseBlocks[walletCheeseProducer][_id_Cheese].quantity = _newQuantity;
    }

    function deleteCheeseBlockIdFromList(uint256 _id)internal returns (bool) {
        for(uint256 i=0; ; i++){
            if(cheeseBlockListId[i] == _id){
                delete  cheeseBlockListId[i];
                return true;
            }
        }
        return false;
    }

}
