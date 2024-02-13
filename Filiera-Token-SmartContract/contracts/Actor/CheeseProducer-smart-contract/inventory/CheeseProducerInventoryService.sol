// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./contracts/Actor/CheeseProducer-smart-contract/inventory/CheeseProducerInventoryStorage.sol";
import "./contracts/Actor/CheeseProducer-smart-contract/CheeseProducerService.sol";
import "./contracts/Actor/CheeseProducer-smart-contract/inventory/CheeseProducerMilkBatchService.sol";


contract CheeseProducerInventoryService {

    // Address of Organization che gestisce gli utenti
    address private cheeseProducerOrg;

    // Address of Consumer Storage 
    CheeseProducerInventoryStorage private cheeseProducerInventoryStorage;

    CheeseProducerService private cheeseProducerService;

    CheeseProducerMilkBatchService private cheeseProducerMilkBatchService;


    // Eventi per notificare l'aggiunta di una Partita di Latte
    event CheeseBlockAdded(address indexed userAddress, string dop, uint256 quantity, uint256 price);

    // Eventi per notificare la rimozione di una Partita di Latte
    event CheeseBlockDeleted(address indexed userAddress);

    constructor(address _cheeseProducerInventoryStorage, address _cheeseProducerService, address _cheeseProducerMilkBatchService) {
        cheeseProducerInventoryStorage = CheeseProducerInventoryStorage(_cheeseProducerInventoryStorage);
        
        cheeseProducerService = CheeseProducerService(_cheeseProducerService);

        cheeseProducerMilkBatchService = CheeseProducerMilkBatchService(_cheeseProducerMilkBatchService);
        
        cheeseProducerOrg = msg.sender;
    }

    // Modifier: 
    // Modifica il comportamento della funzione applicando una particolare condizione e un particolare comportamento aggiuntivo
    modifier onlyIfUserPresent() {

        require(msg.sender != cheeseProducerOrg, "Address not valid!");
        require(msg.sender != address(cheeseProducerInventoryStorage), "Address not valid of Inventory Storage");
        require(msg.sender != address(cheeseProducerService),"Address not valid of Service");
        require(cheeseProducerService.isUserPresent(msg.sender), "User is not present in data");
        _;
    }

    /* Questa funzione permette di aggiungere : 
       Un prodotto CheeseBlock all'inventario da poter mettere in vendita
       
       - Check da effettuare : 
       - Verifica che l'address dell'utente sia registrato 
       - Verifica che l'address dell'utente non sia l'organizzazione che ha deployato il contratto 
       
       - Evento : 
       - CheeseBlockAdded()
     */
    function insertCheeseBlock(string memory _dop, uint256 _quantity, uint256 _price) external {
        // Verifico che l'address sia diverso da quello di Deploy 
        require(msg.sender == cheeseProducerOrg, "Address non Valido!");

        cheeseProducerInventoryStorage.addCheeseBlock(msg.sender, _dop, _quantity, _price);

        emit CheeseBlockAdded(msg.sender, _dop, _quantity, _price);
    }

    /**
     * Ottenere le informazioni del cheeseblock attraverso : 
     * - ID 
     * */  
    function fetchCheeseBlock(uint256 _id) external view returns (uint256, string memory, uint256, uint256) {
        address walletCheeseProducer = msg.sender;

        require(walletCheeseProducer == cheeseProducerOrg, "Address non Valido!");

        return cheeseProducerInventoryStorage.getCheeseBlock(walletCheeseProducer, _id);
    }

    /**
     * Eliminare un Cheese Block attraverso l'id 
     * - ID 
     * - Verficare che l'utente che vuole eseguire la transazione sia presente.
     */
    function removeCheeseBlock(uint256 _id) external {
        address walletCheeseProducer = msg.sender;
        
        require(walletCheeseProducer == cheeseProducerOrg, "Address non Valido!");

        require(cheeseProducerInventoryStorage.deleteCheeseBlock(walletCheeseProducer, _id), "Errore durante la cancellazione");

        emit CheeseBlockDeleted(walletCheeseProducer);
    }

    function getDop(address walletCheeseProducer, uint256 _id) external view returns(string memory) {
        return cheeseProducerInventoryStorage.getDop(walletCheeseProducer,_id);        
    }

    function getPrice(address walletCheeseProducer, uint256 _id) external view returns(uint256) {
        return cheeseProducerInventoryStorage.getPrice(walletCheeseProducer,_id);        
    }

    function getQuantity(address walletCheeseProducer, uint256 _id) external view returns(uint256) {
        return cheeseProducerInventoryStorage.getQuantity(walletCheeseProducer,_id);        
    }

    function transformMilkBatch(address walletCheeseProducer, uint256 _id, uint256 quantityToTransform, uint256 pricePerKg, string memory dop) external view {
        //Verifico che il prodotto esiste, che la quantità richiesta da trasformare non ecceda il massimo consentito
        //TODO: gestire data di scadenza nel frontend
        require(cheeseProducerMilkBatchService.checkMilkBatch(walletCheeseProducer, _id, quantityToTransform), "Il check della Partita del Latte non e' andato a buon fine!");

        cheeseProducerMilkBatchService.decreaseMilkBatchQuantity(_id, quantityToTransform);

        uint256 weight = quantityToTransform * 5;
        //TODO: gestire il prezzo con SafeMath
        insertCheeseBlock(dop, weight, weight * pricePerKg);
    }

}
