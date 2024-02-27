// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./CheeseProducerInventoryStorage.sol";
import "../CheeseProducerService.sol";
import "./CheeseProducerMilkBatchService.sol";

import "../../../Service/AccessControlProduct.sol";


// NOTA : implementare i controlli semplici e non di autorizzazione perchè i retailer possono vedere le varie info in merito ai prodotti dei CheeseProducer 
// NOTA : Nel service che gestisce lo storage di acquisto, bisogna implementare una logica più restrittiva che ci dà la possibilità di far visualizzare i prodotti acquistati a coloro che li acquistati.
// NOTA : Ricorda di implementare una logica di approvazione per il contratto che esegue l'aggiunta dell'oggetto acquistato ( TransactionManager deve essere approvato per poter eseguire una transazione del genere ) 

contract CheeseProducerInventoryService {

//--------------------------------------------------------------------- Address of Service Contract -----------------------------------------------//

    // Address of Organization che gestisce gli utenti
    address private cheeseProducerOrg;

    // Address of Consumer Storage 
    CheeseProducerInventoryStorage private cheeseProducerInventoryStorage;

    CheeseProducerService private cheeseProducerService;

    CheeseProducerMilkBatchService private cheeseProducerMilkBatchService;

    // Address Access Control 
    AccessControlProduct private accessControlProduct;

//--------------------------------------------------------------------- Event of Service Contract -----------------------------------------------//

    // Eventi per notificare l'aggiunta di una Partita di Latte
    event CheeseBlockAdded(address indexed userAddress,string message,uint256 id, string dop, uint256 quantity, uint256 price);

    // Eventi per notificare la rimozione di un CheeseBlock
    event CheeseBlockDeleted(address indexed userAddress, string message, uint256 _id);
    
    // Eventi per notificare la modifica di un Cheese Block 
    event CheeseBlockEdited(address indexed userAddress,string message, uint256 quantity);


//--------------------------------------------------------------------- Constructor of Service Contract -----------------------------------------------//


    constructor(
        address _cheeseProducerInventoryStorage,
        address _cheeseProducerService,
        address _cheeseProducerMilkBatchService,
        address _accessControlProduct) {
        
        cheeseProducerInventoryStorage = CheeseProducerInventoryStorage(_cheeseProducerInventoryStorage);
        
        cheeseProducerService = CheeseProducerService(_cheeseProducerService);

        cheeseProducerMilkBatchService = CheeseProducerMilkBatchService(_cheeseProducerMilkBatchService);
        
        accessControlProduct = AccessControlProduct(_accessControlProduct);

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

    // TODO : Aggiungere il controllo per l'organizzazione che può effettuare il cambio dei vari Address di Service di cui abbiamo bisogno

//--------------------------------------------------------------------- Business Function of Service Contract -----------------------------------------------//


    /* Questa funzione permette di aggiungere : 
       Un prodotto CheeseBlock all'inventario da poter mettere in vendita
       
       - Check da effettuare : 
       - Verifica che l'address dell'utente sia registrato 
       - Verifica che l'address dell'utente non sia l'organizzazione che ha deployato il contratto 
       
       - Evento : 
       - CheeseBlockAdded()
     */
    function addCheeseBlock(
        address _walletCheeseProducer,
        uint256 _id_MilkBatchAcquistato,
        string memory _dop,
        uint256 _quantity,
        uint256 _price) internal  checkAddress(_walletCheeseProducer) {
        
        require(cheeseProducerService.isUserPresent(_walletCheeseProducer), "User is not present in data");
        
        (uint id_Cheese,string memory dop, uint256 pricePerKg, uint256 quantityToTal) = cheeseProducerInventoryStorage.addCheeseBlock(_walletCheeseProducer, _id_MilkBatchAcquistato, _dop, _quantity, _price);

        emit CheeseBlockAdded(_walletCheeseProducer,"MilkBatch convertito con successo ! Ecco il nuovo cheeseBlock!",id_Cheese, dop, quantityToTal, pricePerKg);
    }

    /**
     * Ottenere le informazioni del cheeseblock attraverso : 
     * - ID cheeseBlock
     * */  
    function getCheeseBlock(uint256 _id_CheeseBlock) external view checkAddress(msg.sender) returns (uint256, string memory, uint256, uint256) {
        
        address walletCheeseProducer = msg.sender;

        require(cheeseProducerService.isUserPresent(walletCheeseProducer), "User is not present in data");

        require(this.isCheeseBlockPresent(walletCheeseProducer, _id_CheeseBlock), "CheeseBlock is not present in data");

        return cheeseProducerInventoryStorage.getCheeseBlock(walletCheeseProducer, _id_CheeseBlock);
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
        require(this.isCheeseBlockPresent(walletCheeseProducer, _id),"Cheese Block not Present!");

        if(cheeseProducerInventoryStorage.deleteCheeseBlock(walletCheeseProducer,_id)){
            emit CheeseBlockDeleted(walletCheeseProducer,"Cheese Block e' stato eleminato", _id);
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

    function getCheeseBlockQuantity(address walletCheeseProducer, uint256 _id) external view returns(uint256) {
        require(cheeseProducerService.isUserPresent(walletCheeseProducer), "User is not present!");

        require(this.isCheeseBlockPresent(walletCheeseProducer, _id),"MilkBatch not Present!");

        return cheeseProducerInventoryStorage.getQuantity(walletCheeseProducer,_id);        
    }

    // Verifica se un determinato CheeseBlock è presente 
    function isCheeseBlockPresent(address walletCheeseProducer, uint256 _id_cheeseBlock) external view  checkAddress(walletCheeseProducer) returns(bool){

        return cheeseProducerInventoryStorage.isCheeseBlockPresent(walletCheeseProducer,_id_cheeseBlock);
    }


     function getCheeseBlockByCheeseProducer(address walletCheeseProducer) external checkAddress(walletCheeseProducer) view returns (CheeseProducerInventoryStorage.Cheese[] memory){
        // Check if exist 
        require(cheeseProducerService.isUserPresent(walletCheeseProducer), "User is not present!");

        return cheeseProducerInventoryStorage.getCheeseBlockByCheeseProducer(walletCheeseProducer);
    }

    /*
        - Recupera tutti i CheeseBlock presenti all'interno di Inventory 
        - Verifica che quel CheeseProducer sia all'interno del sistema 
    */
    function getAllCheeseBlockList(address walleRetailer) view  external  returns (CheeseProducerInventoryStorage.Cheese[] memory){
        require(accessControlProduct.checkViewCheeseBlockProduct(walleRetailer),"User Not Authorized!");
            address[] memory addressListCheeseBlock = cheeseProducerService.getListAddressCheeseProducer();

            return cheeseProducerInventoryStorage.getAllCheeseBlockList(addressListCheeseBlock); 
    }

//--------------------------------------------------------------------- Update Function of Service Contract -----------------------------------------------//

    // Funzione per trasformare i vari milkBatch in CheeseBlock 
    function transformMilkBatch(address walletCheeseProducer, uint256 _id_MilkBatchAcquistato, uint256 quantityToTransform, uint256 pricePerKg, string memory dop) external  {
        
        //Verifico che il prodotto esiste, che la quantità richiesta da trasformare non ecceda il massimo consentito
        require(cheeseProducerMilkBatchService.isMilkBatchAcquistataPresent(walletCheeseProducer,_id_MilkBatchAcquistato),"Prodotto non presente!");
        // Verifico la quantità 
        // Verifico che quella che devo trasformare sia inferiore o uguale a quella che ho acquistato 
        require(quantityToTransform<=cheeseProducerMilkBatchService.getQuantity(walletCheeseProducer,_id_MilkBatchAcquistato),"Quantita' da trasformare non valida!");

        uint256 _newQuantity = cheeseProducerMilkBatchService.getQuantity(walletCheeseProducer,_id_MilkBatchAcquistato) - quantityToTransform;

        //TODO: gestire data di scadenza nel frontend ( Verificare la data di Scadenza con quella Odierna ) 
        cheeseProducerMilkBatchService.updateMilkBatchQuantity(walletCheeseProducer,_id_MilkBatchAcquistato, _newQuantity);

        uint256 weight = quantityToTransform * 5;
        //TODO: gestire il prezzo con SafeMath
        addCheeseBlock(walletCheeseProducer,_id_MilkBatchAcquistato, dop, weight,pricePerKg);
    }


// --------------------------------------------------------------------- SET function --------------------------------------------------------------------------------------------//


    /**
    * Decremento della quantità del CheeseBlock 
    * Verifica che la quantità sia maggiore di 0 -> altrimenti rimani 
    */
    function updateCheeseBlockQuantity(address ownerCheeseProducer, uint256 _id, uint256 _quantity) external checkAddress(ownerCheeseProducer) {

        require(cheeseProducerService.isUserPresent(ownerCheeseProducer), "User is not present!");

        require(this.isCheeseBlockPresent(ownerCheeseProducer, _id),"MilkBatch not Present!");

        cheeseProducerInventoryStorage.updateCheeseBlockQuantity(ownerCheeseProducer, _id, _quantity);

        emit CheeseBlockEdited(ownerCheeseProducer,"CheeseBlock edited!", _quantity);
    }

}
