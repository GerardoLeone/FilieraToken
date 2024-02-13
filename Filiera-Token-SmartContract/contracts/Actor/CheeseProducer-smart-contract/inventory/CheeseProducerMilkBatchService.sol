// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;



import "./CheeseProducerMilkBatchStorage.sol";
import "contracts/Actor/CheeseProducer-smart-contract/CheeseProducerService.sol";


contract CheeseProducerMilkBatchService {



//------------------------------------------------------------------------ Address of other Contract Service -----------------------------------------------------------//

    // Address of Organization che gestisce gli utenti
    address private cheeseProducerOrg;
    // Address of MilkBatchStorage 
    CheeseProducerMilkBatchStorage private cheeseProducerMilkBatchStorage;

    CheeseProducerService private cheeseProducerService;


//------------------------------------------------------------------------ Event of Service  -----------------------------------------------------------//

    // Eventi per notificare l'aggiunta di una Partita di Latte
    event CheeseProducerMilkBatchAdded(address indexed userAddress,string message, string expirationDate, uint256 quantity);
    // Evento per notificare che un MilkBatch è stato eliminato 
    event CheeseProducerMilkBatchDeleted(address indexed userAddress, string message);
    // Evento per notificare che un MilkBatch è stato Editato
    event CheeseProducerMilkBatchEdited(address indexed userAddress,string message, uint256 quantity);


//------------------------------------------------------------------------ Constructor of other Contract Service -----------------------------------------------------------//

    constructor(address _cheeseProducerMilkBatchStorage, address _cheeseProducerService) {
        cheeseProducerMilkBatchStorage = CheeseProducerMilkBatchStorage(_cheeseProducerMilkBatchStorage);
        cheeseProducerService = CheeseProducerService(_cheeseProducerService);
        cheeseProducerOrg = msg.sender;
    }

//------------------------------------------------------------------------ Modifier Logic of Contract Service -----------------------------------------------------------//

    modifier checkAddress(address caller){
        
        require(caller!=address(0),"Address value is 0!");
        require(caller!=address(cheeseProducerMilkBatchStorage),"Address is cheeseProducerMilkBatchStorage!");
        require(caller!=address(cheeseProducerService),"Address is CheeseProducerService!");
        require(caller!=address(cheeseProducerOrg),"Address is Organization!");
        _;
    }

//------------------------------------------------------------------------ Business Logic of Contract Service -----------------------------------------------------------//

    /**
    * Tale funzione viene chiamata dal TransactionManager per inserire il MilkBatch venduto dal MilkHub al CheeseProducer 
    * I controlli vengono fatti tutti all'interno del TransactionManager per la verifica dell'esistenza dei due interessati 
    
    * - verifichiamo che il CheeseProducer e il MilkHub esistono 
    * - verifichiamo che il MilkBatch associato al MilkHub esiste 
    * - verifichiamo anche la quantità del MilkBatch 
    */
    function addMilkBatch(address _walletMilkHub, address _walletCheeseProducer, string memory _expirationDate, uint256 _quantity) external checkAddress(msg.sender){
        // Aggiungo il MilkBatch all'interno dell'Inventario del CheeseProducer 
        cheeseProducerMilkBatchStorage.addMilkBatch(_walletCheeseProducer, _walletMilkHub, _expirationDate, _quantity);

        emit CheeseProducerMilkBatchAdded(_walletCheeseProducer,"MilkBatch Acquistato!", _expirationDate, _quantity);
    }


    function getMilkBatch(uint256 _id) external view returns (uint256, address, string memory, uint256) {
        address walletCheeseProducer = msg.sender;

        require(walletCheeseProducer == cheeseProducerOrg, "Address non Valido!");

        return cheeseProducerMilkBatchStorage.getMilkBatch(walletCheeseProducer, _id);
    }

    

    function getExpirationDate(address walletCheeseProducer, uint256 _id) external view returns(string memory) {
        return cheeseProducerMilkBatchStorage.getExpirationDate(walletCheeseProducer,_id);        
    }

    function getQuantity(address walletCheeseProducer, uint256 _id) external view returns(uint256) {
        return cheeseProducerMilkBatchStorage.getQuantity(walletCheeseProducer,_id);        
    }

    function getPrice(address walletCheeseProducer, uint256 _id) external view returns(address) {
        return cheeseProducerMilkBatchStorage.getWalletMilkHub(walletCheeseProducer,_id);        
    }

    function checkMilkBatch(address walletCheeseProducer, uint256 _id, uint256 _quantityToTransform) external view returns (bool){
        require(msg.sender != address(0),"Address not Valid!");
        require(walletCheeseProducer != address(0),"Address not Valid!");

        return cheeseProducerMilkBatchStorage.checkMilkBatch(walletCheeseProducer, _id, _quantityToTransform);  
    }

//-------------------------------------------------------------------- Set Function ------------------------------------------------------------------------//

    /**
    *
    * Funzione che diminuisce la quantità del MilkBatch Acquistato 
    * 
    *
    */
    function decreaseMilkBatchQuantity(uint256 _id, uint256 _quantity) external {
        address walletCheeseProducer = msg.sender;

        require(walletCheeseProducer == cheeseProducerOrg, "Address non Valido!");

        require(cheeseProducerMilkBatchStorage.detractMilkBatchQuantity(walletCheeseProducer, _id, _quantity), "Errore durante la modifica della quantita' di latte nella Partita del Latte");

        emit CheeseProducerMilkBatchEdited(walletCheeseProducer,"MilkBatch e' stato modificato!", _quantity);
    }





// -------------------------------------------------- Change Address Function Contract Service ---------------------------------------------------//


    // TODO: insert modifier onlyOrg(address sender) {}
    function changeCheeseProducerMilkBatchStorage(address _cheeseProducerMilkBatchStorage)external {
        require(msg.sender == cheeseProducerOrg,"Address is not the organization");
        cheeseProducerMilkBatchStorage = CheeseProducerMilkBatchStorage(_cheeseProducerMilkBatchStorage);
    }

    // TODO: insert modifier onlyOrg(address sender) {}
    function changeCheeseProducerService(address _cheeseProducerService) external {
        cheeseProducerService = CheeseProducerService(_cheeseProducerService);
    }

}