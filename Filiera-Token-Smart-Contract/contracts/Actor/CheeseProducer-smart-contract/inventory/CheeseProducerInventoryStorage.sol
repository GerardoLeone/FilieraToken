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

    mapping(address => mapping(uint256 => Cheese)) private cheeseBlocks; // map of CheeseBlock 

    mapping( address => uint256[] ) cheeseBlockIdListForSingleCheeseProducer; // List of id of Single User CheeseProducer 

    uint256 [] private cheeseBlockListId; // All CheeseBlock 

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
        // Inserisce l'id all'interno della Lista del CheeseProducer 
        cheeseBlockIdListForSingleCheeseProducer[walletCheeseProducer].push(_id);
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
        if(cheeseBlocks[walletCheeseProducer][_id].id  == 0 && 
        deleteCheeseBlockIdFromList(_id) && 
        deleteCheeseBlockIdFromListSingleUser(_id, walletCheeseProducer) ){
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


    /*
    * Restituisce la Lista di tutti gli ID dei prodotti di un determinato utente
    */
    function getListCheeseBlockIdByCheeseProducer(address walletCheeseProducer)external view returns (uint256[] memory){
        return cheeseBlockIdListForSingleCheeseProducer[walletCheeseProducer];
    }
    
    // Restituisce tutti i CheeseBlock per i Retailer 
    function getListCheeseBlockAll()external view returns(uint256[]memory){
        return cheeseBlockListId;
    }
// --------------------------------------------------- Set Function --------------------------------------------------------------------------------------//


    // - Funzione updateCheeseBlockQuantity() aggiorna la quantità del CheeseBlock 
    function updateCheeseBlockQuantity(
        address walletCheeseProducer,
        uint256 _id_Cheese,
        uint256 _newQuantity) external  {
        
        // Controllo sulla quantita' 
        require(_newQuantity<=cheeseBlocks[walletCheeseProducer][_id_Cheese].quantity,"Controllo della Quantita' da utilizzare non andata a buon fine!");

        cheeseBlocks[walletCheeseProducer][_id_Cheese].quantity = _newQuantity;
    }

    function deleteCheeseBlockIdFromList(uint256 _id)internal returns (bool) {
        for(uint256 i=0; ; i++){
            if(cheeseBlockListId[i] == _id ){
                delete  cheeseBlockListId[i];
                return true;
            }
        }
        return false;
    }

    function deleteCheeseBlockIdFromListSingleUser(uint256 _id, address walletCheeseProducer)internal returns (bool) {
        for(uint256 i=0; ; i++){
            if(cheeseBlockIdListForSingleCheeseProducer[walletCheeseProducer][i] == _id){
                delete cheeseBlockIdListForSingleCheeseProducer[walletCheeseProducer][i];
                return true;
            }
        }
        return false;
    }

}
