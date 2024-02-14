// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./CheeseProducerInventoryStorage.sol";
import "../CheeseProducerService.sol";
import "./CheeseProducerMilkBatchService.sol";


contract CheeseProducerInventoryService {


//--------------------------------------------------------------------- Address of Service Contract -----------------------------------------------//

    // Address of Organization che gestisce gli utenti
    address private cheeseProducerOrg;

    // Address of Consumer Storage 
    CheeseProducerInventoryStorage private cheeseProducerInventoryStorage;

    CheeseProducerService private cheeseProducerService;

    CheeseProducerMilkBatchService private cheeseProducerMilkBatchService;

//--------------------------------------------------------------------- Event of Service Contract -----------------------------------------------//

    // Eventi per notificare l'aggiunta di una Partita di Latte
    event CheeseBlockAdded(address indexed userAddress,string message, string dop, uint256 quantity, uint256 price);

    // Eventi per notificare la rimozione di una Partita di Latte
    event CheeseBlockDeleted(address indexed userAddress, string message, uint256 _id);

//--------------------------------------------------------------------- Constructor of Service Contract -----------------------------------------------//


    constructor(address _cheeseProducerInventoryStorage, address _cheeseProducerService, address _cheeseProducerMilkBatchService) {
        cheeseProducerInventoryStorage = CheeseProducerInventoryStorage(_cheeseProducerInventoryStorage);
        
        cheeseProducerService = CheeseProducerService(_cheeseProducerService);

        cheeseProducerMilkBatchService = CheeseProducerMilkBatchService(_cheeseProducerMilkBatchService);
        
        cheeseProducerOrg = msg.sender;
    }

//--------------------------------------------------------------------- Modifier of Service Contract -----------------------------------------------//

    modifier checkAddress(address caller) {
        require(caller != address(0),"Address Value is Zero!");
        require(caller != cheeseProducerOrg, "Address not valid!");
        require(caller != address(cheeseProducerInventoryStorage), "Address not valid of Inventory Storage");
        require(caller != address(cheeseProducerService),"Address not valid of Service");
        _;
    }


//--------------------------------------------------------------------- Business Function of Service Contract -----------------------------------------------//


    /* Questa funzione permette di aggiungere : 
       Un prodotto CheeseBlock all'inventario da poter mettere in vendita
       
       - Check da effettuare : 
       - Verifica che l'address dell'utente sia registrato 
       - Verifica che l'address dell'utente non sia l'organizzazione che ha deployato il contratto 
       
       - Evento : 
       - CheeseBlockAdded()
     */
    function addCheeseBlock(address walletCheeseProducer, string memory _dop, uint256 _quantity, uint256 _price) external checkAddress(walletCheeseProducer) {
        
        require(cheeseProducerService.isUserPresent(walletCheeseProducer), "User is not present in data");
        
        cheeseProducerInventoryStorage.addCheeseBlock(walletCheeseProducer, _dop, _quantity, _price);

        emit CheeseBlockAdded(walletCheeseProducer,"CheeseBlock convertito con successo !", _dop, _quantity, _price);
    }

    /**
     * Ottenere le informazioni del cheeseblock attraverso : 
     * - ID cheeseBlock
     * */  
    function getCheeseBlock(uint256 _id) external view checkAddress(msg.sender) returns (uint256, string memory, uint256, uint256) {
        
        address walletCheeseProducer = msg.sender;

        require(this.isCheeseBlockPresent(walletCheeseProducer, _id), "CheeseBlock is not present in data");

        return cheeseProducerInventoryStorage.getCheeseBlock(walletCheeseProducer, _id);
    }

    /**
     * Eliminare un Cheese Block attraverso l'id 
     * - ID 
     * - Verficare che l'utente che vuole eseguire la transazione sia presente.
     */
    function deleteCheeseBlock(uint256 _id) external returns(bool){
        // Retrieve msg.sender 
        address walletCheeseProducer = msg.sender;
        // Check if User is Present
        require(cheeseProducerService.isUserPresent(walletCheeseProducer), "User is not present!");
        // Check if Product is present 
        require(this.isCheeseBlockPresent(walletCheeseProducer, _id),"MilkBatch not Present!");

        if(cheeseProducerInventoryStorage.deleteCheeseBlock(walletCheeseProducer,_id)){
            emit CheeseBlockDeleted(walletCheeseProducer,"Pezzo di Formaggio e' stato eleminato", _id);
            return true;
        }else {
            return false;
        }

    }

//--------------------------------------------------------------------- Get Function of Service Contract -----------------------------------------------//

    function getDop(address walletCheeseProducer, uint256 _id) external view returns(string memory) {
        require(cheeseProducerService.isUserPresent(walletCheeseProducer), "User is not present!");

        require(this.isCheeseBlockPresent(walletCheeseProducer, _id),"MilkBatch not Present!");

        return cheeseProducerInventoryStorage.getDop(walletCheeseProducer,_id);        
    }

    function getPrice(address walletCheeseProducer, uint256 _id) external view returns(uint256) {
        require(cheeseProducerService.isUserPresent(walletCheeseProducer), "User is not present!");

        require(this.isCheeseBlockPresent(walletCheeseProducer, _id),"MilkBatch not Present!");

        return cheeseProducerInventoryStorage.getPrice(walletCheeseProducer,_id);        
    }

    function getQuantity(address walletCheeseProducer, uint256 _id) external view returns(uint256) {
        require(cheeseProducerService.isUserPresent(walletCheeseProducer), "User is not present!");

        require(this.isCheeseBlockPresent(walletCheeseProducer, _id),"MilkBatch not Present!");

        return cheeseProducerInventoryStorage.getQuantity(walletCheeseProducer,_id);        
    }

    // Verifica se un determinato CheeseBlock è presente 
    function isCheeseBlockPresent(address walletCheeseProducer, uint256 _id_cheeseBlock) external view  checkAddress(walletCheeseProducer) returns(bool){

        return cheeseProducerInventoryStorage.isCheeseBlockPresent(walletCheeseProducer,_id_cheeseBlock);
    }

//--------------------------------------------------------------------- Update Function of Service Contract -----------------------------------------------//

    // Funzione per trasformare i vari milkBatch in CheeseBlock 
    function transformMilkBatch(address walletCheeseProducer, uint256 _id, uint256 quantityToTransform, uint256 pricePerKg, string memory dop) external  {
        //Verifico che il prodotto esiste, che la quantità richiesta da trasformare non ecceda il massimo consentito
        //TODO: gestire data di scadenza nel frontend
        require(cheeseProducerMilkBatchService.checkMilkBatch(walletCheeseProducer, _id, quantityToTransform), "Il check della Partita del Latte non e' andato a buon fine!");

        cheeseProducerMilkBatchService.updateMilkBatchQuantity(walletCheeseProducer,_id, quantityToTransform);

        uint256 weight = quantityToTransform * 5;
        //TODO: gestire il prezzo con SafeMath
        this.addCheeseBlock(walletCheeseProducer, dop, weight, weight * pricePerKg);
    }

}
