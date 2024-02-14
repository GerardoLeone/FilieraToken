// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./ConsumerBuyerInventoryStorage.sol";
import "../ConsumerService.sol";

contract ConsumerBuyerCheesePieceService {

    //------------------------------------------------------------------------ Address of other Contract Service -----------------------------------------------------------//

    // Address of Organization che gestisce gli utenti
    address private consumerBuyerOrg;
    // Address of CheesePieceStorage 
    ConsumerBuyerInventoryStorage private consumerBuyerInventoryStorage;

    ConsumerService private consumerService;

    //------------------------------------------------------------------------ Event of Service  -----------------------------------------------------------//

    // Eventi per notificare l'aggiunta di una Partita di CheesePiece
    event ConsumerBuyerCheesePieceAdded(address indexed userAddress, string message, uint256 id, uint256 price, uint256 quantity);
    // Evento per notificare che un CheesePiece è stato eliminato 
    event ConsumerBuyerCheesePieceDeleted(address indexed userAddress, string message);
    // Evento per notificare che un CheesePiece è stato Editato
    event ConsumerBuyerCheesePieceEdited(address indexed userAddress, string message, uint256 quantity);

    //------------------------------------------------------------------------ Constructor of other Contract Service -----------------------------------------------------------//

    constructor(address _consumerBuyerInventoryStorage, address _consumerService) {
        consumerBuyerInventoryStorage = ConsumerBuyerInventoryStorage(_consumerBuyerInventoryStorage);
        consumerService = ConsumerService(_consumerService);
        consumerBuyerOrg = msg.sender;
    }

    //------------------------------------------------------------------------ Modifier Logic of Contract Service -----------------------------------------------------------//

    modifier checkAddress(address caller) {
        require(caller != address(0), "Address value is 0!");
        require(caller != address(consumerBuyerInventoryStorage), "Address is consumerBuyerInventoryStorage!");
        require(caller != address(consumerService), "Address is ConsumerBuyerService!");
        require(caller != address(consumerBuyerOrg), "Address is Organization!");
        _;
    }

    //------------------------------------------------------------------------ Business Logic of Contract Service -----------------------------------------------------------//

    /**
    * Tale funzione viene chiamata dal TransactionManager per inserire il CheesePiece venduto dal Retailer al ConsumerBuyer 
    * I controlli vengono fatti tutti all'interno del TransactionManager per la verifica dell'esistenza dei due interessati 
    * - Ammettiamo che i controlli sul prodotto vengono già fatti a monte 
    * - verifichiamo che il ConsumerBuyer e il Retailer esistono 
    * - verifichiamo che il CheesePiece associato al Retailer esiste 
    * - Aggiungiamo questi dati all'interno del Inventory 
    */
    function addCheesePiece(
        address _walletRetailer,
        address _walletConsumerBuyer,
        uint256 _id_CheesePiece,
        uint256 _price,
        uint256 _weight
    ) external checkAddress(_walletConsumerBuyer) checkAddress(_walletRetailer) {

        // Verifico che ConsumerBuyer e Retailer address non siano identici
        require(address(_walletConsumerBuyer) != address(_walletRetailer), "Address uguali ConsumerBuyer e Retailer!");

        // Verifico che il ConsumerBuyer è presente 
        require(consumerService.isUserPresent(_walletConsumerBuyer), "Utente non trovato!");

        // Aggiungo il CheesePiece all'interno dell'Inventario del ConsumerBuyer 
        (uint256 id_CheesePiece_Acquistato, uint256 price, uint256 weight) = consumerBuyerInventoryStorage.addCheesePiece(_walletConsumerBuyer, _walletRetailer, _id_CheesePiece, _price, _weight);

        // Invio dell'Evento 
        emit ConsumerBuyerCheesePieceAdded(_walletConsumerBuyer, "CheesePiece Acquistato!", id_CheesePiece_Acquistato, price, weight);
    }

    //TODO : Controllo sull'owner del CheesePiece Acquistato 
    function getCheesePiece(uint256 _id_CheesePieceAcquistato) external view checkAddress(msg.sender) returns (uint256, address, uint256, uint256) {

        address _walletConsumerBuyer = msg.sender;

        require(consumerService.isUserPresent(_walletConsumerBuyer), "Utente non trovato!");

        require(this.isCheesePiecePresent(_walletConsumerBuyer, _id_CheesePieceAcquistato), "Prodotto non Presente!");

        return consumerBuyerInventoryStorage.getCheesePiece(_walletConsumerBuyer, _id_CheesePieceAcquistato);
    }

    function getPrice(address _walletConsumerBuyer, uint256 _id_CheesePieceAcquistato) external view checkAddress(msg.sender) returns (uint256) {

        require(consumerService.isUserPresent(_walletConsumerBuyer), "Utente non trovato!");

        require(this.isCheesePiecePresent(_walletConsumerBuyer, _id_CheesePieceAcquistato), "Prodotto non Presente!");

        return consumerBuyerInventoryStorage.getPrice(_walletConsumerBuyer, _id_CheesePieceAcquistato);
    }

    function getWeight(address _walletConsumerBuyer, uint256 _id_CheesePieceAcquistato) external view checkAddress(msg.sender) returns (uint256) {

        require(consumerService.isUserPresent(_walletConsumerBuyer), "Utente non trovato!");

        require(this.isCheesePiecePresent(_walletConsumerBuyer, _id_CheesePieceAcquistato), "Prodotto non Presente!");

        return consumerBuyerInventoryStorage.getWeight(_walletConsumerBuyer, _id_CheesePieceAcquistato);
    }

    function getWalletRetailer(address _walletConsumerBuyer, uint256 _id_CheesePieceAcquistato) external view checkAddress(msg.sender) returns (address) {

        require(consumerService.isUserPresent(_walletConsumerBuyer), "Utente non trovato!");

        require(this.isCheesePiecePresent(_walletConsumerBuyer, _id_CheesePieceAcquistato), "Prodotto non Presente!");

        return consumerBuyerInventoryStorage.getWalletRetailer(_walletConsumerBuyer, _id_CheesePieceAcquistato);
    }

    /**
    * Verifica che il CheesePiece è presente all'interno dell'inventario 
    * - Verifica che l'id non sia nullo e che sia maggiore di 0 e che coincida con l'elemento 
    */
    function isCheesePiecePresent(address _walletConsumerBuyer, uint256 _id_CheesePieceAcquistato) external view checkAddress(_walletConsumerBuyer) returns (bool) {

        require(consumerService.isUserPresent(_walletConsumerBuyer), "Utente non presente!");

        return consumerBuyerInventoryStorage.isCheesePiecePresent(_walletConsumerBuyer, _id_CheesePieceAcquistato);
    }

    //-------------------------------------------------------------------- Set Function ------------------------------------------------------------------------//


    // -------------------------------------------------- Change Address Function Contract Service ---------------------------------------------------//

    // TODO: insert modifier onlyOrg(address sender) {}
    function changeConsumerBuyerCheesePieceStorage(address _consumerBuyerInventoryStorage) external {
        require(msg.sender == consumerBuyerOrg, "Address is not the organization");
        consumerBuyerInventoryStorage = ConsumerBuyerInventoryStorage(_consumerBuyerInventoryStorage);
    }

    // TODO: insert modifier onlyOrg(address sender) {}
    function changeConsumerBuyerService(address _consumerService) external {
        consumerService = ConsumerService(_consumerService);
    }

}
