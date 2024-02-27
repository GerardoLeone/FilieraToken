// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./RetailerCheeseBlockStorage.sol";
import "../RetailerService.sol";


contract RetailerCheeseBlockService {

//------------------------------------------------------------------------ Address of other Contract Service -----------------------------------------------------------//

    // Address of Organization che gestisce gli utenti
    address private retailerOrg;
    // Address of CheeseBlockStorage 
    RetailerCheeseBlockStorage private retailerCheeseBlockStorage;

    RetailerService private retailerService;

//------------------------------------------------------------------------ Event of Service  -----------------------------------------------------------//

    // Eventi per notificare l'aggiunta di una Partita di Latte
    event RetailerCheeseBlockAdded(address indexed userAddress,string message,uint256 id, string expirationDate, uint256 quantity);
    // Evento per notificare che un CheeseBlock è stato eliminato 
    event RetailerCheeseBlockDeleted(address indexed userAddress, string message);
    // Evento per notificare che un CheeseBlock è stato Editato
    event RetailerCheeseBlockEdited(address indexed userAddress,string message, uint256 quantity);

//------------------------------------------------------------------------ Constructor of other Contract Service -----------------------------------------------------------//

    constructor(address _retailerCheeseBlockStorage, address _retailerService) {
        retailerCheeseBlockStorage = RetailerCheeseBlockStorage(_retailerCheeseBlockStorage);
        retailerService = RetailerService(_retailerService);
        retailerOrg = msg.sender;
    }

//------------------------------------------------------------------------ Modifier Logic of Contract Service -----------------------------------------------------------//

    modifier checkAddress(address caller){
        
        require(caller!=address(0),"Address value is 0!");
        require(caller!=address(retailerCheeseBlockStorage),"Address is retailerCheeseBlockStorage!");
        require(caller!=address(retailerService),"Address is RetailerService!");
        require(caller!=address(retailerOrg),"Address is Organization!");
        _;
    }

//------------------------------------------------------------------------ Business Logic of Contract Service -----------------------------------------------------------//

    // Prodotti Acquistati devono essere visualizzati solo dal Retailer che li detiene 
    // TODO : Controllo del msg.sender sulle funzioni di GET 


    /**
    * Tale funzione viene chiamata dal TransactionManager per inserire il CheeseBlock venduto dal MilkHub al Retailer 
    * I controlli vengono fatti tutti all'interno del TransactionManager per la verifica dell'esistenza dei due interessati 
    * - Ammettiamo che i controlli sul prodotto vengono già fatti a monte 
    * - verifichiamo che il Retailer e il MilkHub esistono 
    * - verifichiamo che il CheeseBlock associato al MilkHub esiste 
    * - Aggiungiamo questi dati all'interno del Inventory 
    */
    function addCheeseBlock(
            
            address _walletCheeseProducer,
            address _walletRetailer,
            uint256 _id_CheeseBlock,
            string memory _dop,
            uint256 _quantity

        ) external checkAddress(_walletRetailer) checkAddress(_walletCheeseProducer) {
        
        // Verifico che Retailer e MilkHub address non sono identici
        require(address(_walletRetailer)!=address(_walletCheeseProducer),"Address uguali Retailer e MilkHub!");

        // Verfico che il Retailer è presente 
        require(retailerService.isUserPresent(_walletRetailer), "Utente non trovato!");

        // Aggiungo il CheeseBlock all'interno dell'Inventario del Retailer 
        (uint256 id_CheeseBlock_Acquistato, string memory _dopCheese,uint256 quantity) = retailerCheeseBlockStorage.addCheeseBlock(_walletRetailer, _walletCheeseProducer, _id_CheeseBlock, _dop, _quantity);

        // Invio dell'Evento 
        emit RetailerCheeseBlockAdded(_walletRetailer,"CheeseBlock Acquistato!", id_CheeseBlock_Acquistato ,  _dopCheese, quantity);
    }

    
    //TODO : Controllo sull'owner del CheeseBlock Acquistato 
    function getCheeseBlock(uint256 _id_CheeseBlockAcquistato) external view checkAddress(msg.sender) returns (uint256, address, string memory, uint256) {
        
        address _walletRetailer = msg.sender;

        require(retailerService.isUserPresent(_walletRetailer), "Utente non trovato!");

        require(this.isCheeseBlockAcquistataPresent(_walletRetailer,_id_CheeseBlockAcquistato),"Prodotto non Presente!");

        return retailerCheeseBlockStorage.getCheeseBlock(_walletRetailer, _id_CheeseBlockAcquistato);
    }


    
    function getDop(address _walletRetailer, uint256 _id_CheeseBlockAcquistato) external view checkAddress(msg.sender) returns(string memory) {
        
        require(retailerService.isUserPresent(_walletRetailer), "Utente non trovato!");

        require(this.isCheeseBlockAcquistataPresent(_walletRetailer,_id_CheeseBlockAcquistato),"Prodotto non Presente!");
        
        return retailerCheeseBlockStorage.getDop(_walletRetailer,_id_CheeseBlockAcquistato);        
    }

    
    function getQuantity(address _walletRetailer, uint256 _id_CheeseBlockAcquistato) external view checkAddress(msg.sender) returns(uint256) {
        
        require(retailerService.isUserPresent(_walletRetailer), "Utente non trovato!");

        require(this.isCheeseBlockAcquistataPresent(_walletRetailer,_id_CheeseBlockAcquistato),"Prodotto non Presente!");
        
        return retailerCheeseBlockStorage.getQuantity(_walletRetailer,_id_CheeseBlockAcquistato);        
    }

    
    function getWalletCheeseProducer(address _walletRetailer, uint256 _id_CheeseBlockAcquistato) external view checkAddress(msg.sender) returns(address) {
        
        require(retailerService.isUserPresent(_walletRetailer), "Utente non trovato!");

        require(this.isCheeseBlockAcquistataPresent(_walletRetailer,_id_CheeseBlockAcquistato),"Prodotto non Presente!");
        
        return retailerCheeseBlockStorage.getWalletCheeseProducer(_walletRetailer,_id_CheeseBlockAcquistato);        
    }

    /**
    * Verifica che il CheeseBlock è presente all'interno dell'inventario 
    * - Verifica che l'id non sia nullo e che sia maggiore di 0 e che coincida con l'elemento 
    */
    function isCheeseBlockAcquistataPresent(address _walletRetailer, uint256 _id_CheeseBlockAcquistato) external view checkAddress(_walletRetailer)  returns (bool){
        
        require(retailerService.isUserPresent(_walletRetailer),"Utente non presente!");

        return retailerCheeseBlockStorage.isCheesePresent(_walletRetailer, _id_CheeseBlockAcquistato);
    }



//-------------------------------------------------------------------- Set Function ------------------------------------------------------------------------//

    /**
    * 
    * - Decremento della quantità del CheeseBlockAcquistato per la trasformazione in Cheese 
    */
    function updateCheeseBlockQuantity(address walletRetailer, uint256 _id_CheeseBlock, uint256 _quantity) external checkAddress(walletRetailer) {

        require(retailerService.isUserPresent(walletRetailer), "User is not present!");

        require(retailerCheeseBlockStorage.isCheesePresent(walletRetailer, _id_CheeseBlock),"CheeseBlock not Present!");

        retailerCheeseBlockStorage.updateCheeseQuantity(walletRetailer, _id_CheeseBlock, _quantity);

        emit RetailerCheeseBlockEdited(walletRetailer,"CheeseBlock edited!", _quantity);
    }




// -------------------------------------------------- Change Address Function Contract Service ---------------------------------------------------//


    // TODO: insert modifier onlyOrg(address sender) {}
    function changeRetailerCheeseBlockStorage(address _retailerCheeseBlockStorage)external {
        require(msg.sender == retailerOrg,"Address is not the organization");
        retailerCheeseBlockStorage = RetailerCheeseBlockStorage(_retailerCheeseBlockStorage);
    }

    // TODO: insert modifier onlyOrg(address sender) {}
    function changeRetailerService(address _retailerService) external {
        retailerService = RetailerService(_retailerService);
    }

}