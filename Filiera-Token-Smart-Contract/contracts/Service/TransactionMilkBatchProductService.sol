// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

import "./Filieratoken.sol";

// Service 
import "../Actor/CheeseProducer-smart-contract/CheeseProducerService.sol";
import "../Actor/MilkHub-smart-contract/MilkHubService.sol";


// Inventory Service 
import "../Actor/MilkHub-smart-contract/inventory/MilkHubInventoryService.sol";
import "../Actor/CheeseProducer-smart-contract/inventory/CheeseProducerBuyerService.sol";



contract TransactionManager {

    // **Main Services**

    // Address of the FilieraToken contract.
    Filieratoken private filieraTokenService;

    // Addresses of the service contracts for each actor in the supply chain.
    MilkHubService private milkhubService;    // Address of the MilkHubService contract.
    CheeseProducerService private cheeseProducerService; // Address of the CheeseProducerService contract.
    // **Inventory Services**

    // Service contracts for managing inventory for each actor and product stage.

    // MilkHub - Contains MilkBatch (product sold by MilkHub).
    MilkHubInventoryService private milkhubInventoryService;

    // CheeseProducer - Contains MilkBatch (product bought by CheeseProducer).
    CheeseProducerBuyerService private cheeseProducerMilkBatchService;


        /**
     * @dev Costruttore del contratto TransactionManager.
     * 
     * @param _filieraToken Indirizzo del contratto FilieraToken.
     * @param _milkhubService Indirizzo del contratto MilkHubService.
     * @param _cheeseProducerService Indirizzo del contratto CheeseProducerService.
     * 
     * @param _milkhubInventoryServiceAddress Indirizzo del contratto MilkHubInventoryService.
     * @param _cheeseProducerMilkBatchServiceAddress Indirizzo del contratto CheeseProducerBuyerService.
     * 
     * 
     */
    constructor(
        address _filieraToken,

        address _milkhubService,
        address _cheeseProducerService,

        address _milkhubInventoryServiceAddress,
        address _cheeseProducerMilkBatchServiceAddress
        ){
        // Filiera Token Service 
        filieraTokenService = Filieratoken(_filieraToken);

        

        // Main Service 

        milkhubService = MilkHubService(_milkhubService);
        cheeseProducerService = CheeseProducerService(_cheeseProducerService);
        
        // Inventory Service 
        milkhubInventoryService = MilkHubInventoryService(_milkhubInventoryServiceAddress);
        cheeseProducerMilkBatchService = CheeseProducerBuyerService(_cheeseProducerMilkBatchServiceAddress);
    }

    /**
     * @dev Funzione per acquistare un MilkBatch da un MilkHub. Questa funzione può essere chiamata solo da un CheeseProducer.
     *
     * @param ownerMilkBatch Indirizzo del MilkHub che vende il MilkBatch.
     * @param _id_MilkBatch Identificativo del MilkBatch da acquistare.
     * @param _quantityToBuy Quantità di MilkBatch da acquistare.
     * @param totalPrice Prezzo totale del MilkBatch da acquistare (espresso in FilieraToken).
     */
    function BuyMilkBatchProduct(
        address ownerMilkBatch,
        uint256 _id_MilkBatch,
        uint256 _quantityToBuy,
        uint256 totalPrice)
         external {

        // Verifica degli address con controlli generici 
        require(msg.sender != address(0), "Invalid sender address");
        require(ownerMilkBatch != address(0), "Invalid owner address");
        require(msg.sender != ownerMilkBatch, "Cannot buy from yourself");
        // Verfica della presenza del Prodotto 
        require(milkhubInventoryService.isMilkBatchPresent(ownerMilkBatch, _id_MilkBatch), "Product not found");
        // Verifica della quantità da acquistare rispetto alla quantità totale 
        require(_quantityToBuy <= milkhubInventoryService.getMilkBatchQuantity(ownerMilkBatch, _id_MilkBatch), "Invalid quantity");
        // Verifica del saldo dell'acquirente 
        require(filieraTokenService.balanceOf(msg.sender) >= totalPrice, "Insufficient balance");

        // Acquisto 
        require(filieraTokenService.transferTokenBuyProduct(msg.sender, ownerMilkBatch, totalPrice),"Acquisto non andato a buon fine!");

        // Aggiornamento del saldo del MilkHub 
        uint256 newMilkHubBalance = filieraTokenService.balanceOf(ownerMilkBatch);
        milkhubService.updateMilkHubBalance(ownerMilkBatch, newMilkHubBalance);
        // Aggiornamento del saldo del CheeseProducer 
        uint256 newCheeseProducerBalance = filieraTokenService.balanceOf(msg.sender);
        cheeseProducerService.updateCheeseProducerBalance(msg.sender, newCheeseProducerBalance);

        // Riduzione della quantità nel MilkHubInventory
        uint256 currentQuantity = milkhubInventoryService.getMilkBatchQuantity(ownerMilkBatch, _id_MilkBatch);
        milkhubInventoryService.updateMilkBatchQuantity(ownerMilkBatch, _id_MilkBatch, currentQuantity - _quantityToBuy);

        // Aggiunta del MilkBatch nell'inventario del CheeseProducer
        cheeseProducerMilkBatchService.addMilkBatch(
            ownerMilkBatch,
            msg.sender, 
            _id_MilkBatch,
            milkhubInventoryService.getMilkBatchExpirationDate(ownerMilkBatch, _id_MilkBatch),
            _quantityToBuy);
    }


}