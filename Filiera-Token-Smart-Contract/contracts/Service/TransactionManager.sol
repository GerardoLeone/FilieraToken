// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

import "./Filieratoken.sol";

// Service 
import "../Actor/CheeseProducer-smart-contract/CheeseProducerService.sol";
import "../Actor/MilkHub-smart-contract/MilkHubService.sol";
import "../Actor/Consumer-smart-contract/ConsumerService.sol";
import "../Actor/Retailer-smart-contract/RetailerService.sol";


// Inventory Service 
import "../Actor/MilkHub-smart-contract/inventory/MilkHubInventoryService.sol";
import "../Actor/CheeseProducer-smart-contract/inventory/CheeseProducerBuyerService.sol";

import "../Actor/CheeseProducer-smart-contract/inventory/CheeseProducerInventoryService.sol";
import "../Actor/Retailer-smart-contract/inventory/RetailerInventoryService.sol";



import "../Actor/Consumer-smart-contract/inventory/ConsumerBuyerInventoryService.sol";
import "../Actor/Retailer-smart-contract/inventory/RetailerBuyerService.sol";



contract TransactionManager {

    // **Main Services**

    // Address of the FilieraToken contract.
    Filieratoken private filieraTokenService;

    // Addresses of the service contracts for each actor in the supply chain.
    MilkHubService private milkhubService;    // Address of the MilkHubService contract.
    CheeseProducerService private cheeseProducerService; // Address of the CheeseProducerService contract.
    RetailerService private retailerService;   // Address of the RetailerService contract.
    ConsumerService private consumerService;   // Address of the ConsumerService contract.

    // **Inventory Services**

    // Service contracts for managing inventory for each actor and product stage.

    // MilkHub - Contains MilkBatch (product sold by MilkHub).
    MilkHubInventoryService private milkhubInventoryService;

    // CheeseProducer - Contains MilkBatch (product bought by CheeseProducer).
    CheeseProducerBuyerService private cheeseProducerMilkBatchService;

    // CheeseProducer - Contains Cheese (product sold by CheeseProducer).
    CheeseProducerInventoryService private cheeseProducerInventoryService;

    // Retailer - Contains CheeseBlock (product bought by Retailer).
    RetailerBuyerService private retailerCheeseBlockService;

    // Retailer - Contains CheesePiece (product sold by Retailer).
    RetailerInventoryService private retailerInventoryService;

    // Consumer - Contains CheesePiece (product bought by Consumer).
    ConsumerBuyerInventoryService private consumerBuyerInventoryService;


        /**
     * @dev Costruttore del contratto TransactionManager.
     * 
     * @param _filieraToken Indirizzo del contratto FilieraToken.
     * @param _milkhubService Indirizzo del contratto MilkHubService.
     * @param _cheeseProducerService Indirizzo del contratto CheeseProducerService.
     * @param _retailerService Indirizzo del contratto RetailerService.
     * @param _consumerService Indirizzo del contratto ConsumerService.
     * 
     * @param _milkhubInventoryServiceAddress Indirizzo del contratto MilkHubInventoryService.
     * @param _cheeseProducerMilkBatchServiceAddress Indirizzo del contratto CheeseProducerBuyerService.
     * 
     * @param _cheeseProducerInventoryService Indirizzo del contratto CheeseProducerInventoryService.
     * @param _retailerCheeseBlockService Indirizzo del contratto RetailerBuyerService.
     * 
     * @param _retailerInventoryService Indirizzo del contratto RetailerInventoryService.
     * @param _consumerBuyerInventoryService Indirizzo del contratto ConsumerBuyerInventoryService.
     */
    constructor(
        address _filieraToken,

        address _milkhubService,
        address _cheeseProducerService,
        address _retailerService,
        address _consumerService,

        address _milkhubInventoryServiceAddress,
        address _cheeseProducerMilkBatchServiceAddress,

        address _cheeseProducerInventoryService,
        address _retailerCheeseBlockService,

        address _retailerInventoryService,
        address _consumerBuyerInventoryService

        ){
        // Filiera Token Service 
        filieraTokenService = Filieratoken(_filieraToken);

        

        // Main Service 

        milkhubService = MilkHubService(_milkhubService);
        cheeseProducerService = CheeseProducerService(_cheeseProducerService);
        
        retailerService = RetailerService(_retailerService);
        consumerService = ConsumerService(_consumerService);

        // Inventory Service 
        milkhubInventoryService = MilkHubInventoryService(_milkhubInventoryServiceAddress);
        cheeseProducerMilkBatchService = CheeseProducerBuyerService(_cheeseProducerMilkBatchServiceAddress);

        cheeseProducerInventoryService = CheeseProducerInventoryService(_cheeseProducerInventoryService);
        retailerCheeseBlockService = RetailerBuyerService(_retailerCheeseBlockService);

        retailerInventoryService = RetailerInventoryService(_retailerInventoryService);
        consumerBuyerInventoryService = ConsumerBuyerInventoryService(_consumerBuyerInventoryService);
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




    /**
    * @dev Funzione per acquistare un CheeseBlock da un CheeseProducer. Questa funzione può essere chiamata solo da un Retailer.
    *
    * @param ownerCheese Indirizzo del CheeseProducer che vende il CheeseBlock.
    * @param _id_Cheese Identificativo del CheeseBlock da acquistare.
    * @param _quantityToBuy Quantità di CheeseBlock da acquistare.
    * @param totalPrice Prezzo totale del CheeseBlock da acquistare (espresso in FilieraToken).
    */ 
    function BuyCheeseProduct(
            address ownerCheese,
            uint256 _id_Cheese,
            uint256 _quantityToBuy,
            uint256 totalPrice // Effettuare il calcolo dal front-End 
        ) external {
       // Verifica degli address con controlli generici 
        require(msg.sender != address(0), "Invalid sender address");
        require(ownerCheese != address(0), "Invalid owner address");
        require(msg.sender != ownerCheese, "Cannot buy from yourself");
        // Verfica della presenza del Prodotto 
        require(cheeseProducerInventoryService.isCheeseBlockPresent(ownerCheese, _id_Cheese), "Product not found");
        // Verifica della quantità da acquistare rispetto alla quantità totale 
        require(_quantityToBuy <= cheeseProducerInventoryService.getCheeseBlockQuantity(ownerCheese, _id_Cheese), "Invalid quantity");
        // Verifica del saldo dell'acquirente 
        require(filieraTokenService.balanceOf(msg.sender) >= totalPrice, "Insufficient balance");

        // Acquisto 
        require(filieraTokenService.transferTokenBuyProduct(msg.sender, ownerCheese, totalPrice),"Acquisto non andato a buon fine!");

        // Aggiornamento del saldo del MilkHub 
        uint256 newCheeseProducerBalance = filieraTokenService.balanceOf(ownerCheese);
        cheeseProducerService.updateCheeseProducerBalance(ownerCheese, newCheeseProducerBalance);
        // Aggiornamento del saldo del CheeseProducer 
        uint256 newRetailerBalance = filieraTokenService.balanceOf(msg.sender);
        retailerService.updateRetailerBalance(msg.sender, newRetailerBalance);

        // Riduzione della quantità nel MilkHubInventory
        uint256 currentQuantity = cheeseProducerInventoryService.getCheeseBlockQuantity(ownerCheese, _id_Cheese);
        cheeseProducerInventoryService.updateCheeseBlockQuantity(ownerCheese, _id_Cheese, currentQuantity - _quantityToBuy);

        // Aggiunta del MilkBatch nell'inventario del CheeseProducer
        retailerCheeseBlockService.addCheeseBlock(
            ownerCheese,
            msg.sender, 
            _id_Cheese,
            cheeseProducerInventoryService.getDop(ownerCheese, _id_Cheese),
            _quantityToBuy);
    }



    /**
     * @dev Funzione per acquistare un CheesePiece da un Retailer. Questa funzione può essere chiamata solo da un Consumer.
     *
     * @param ownerCheesePiece Indirizzo del Retailer che vende il CheesePiece.
     * @param _id_CheesePiece Identificativo del CheesePiece da acquistare.
     * @param _quantityToBuy Quantità di CheesePiece da acquistare (espressa in grammi).
     * @param totalPrice Prezzo totale del CheesePiece da acquistare (espresso in FilieraToken).
     */ 
    function BuyCheesePieceProduct(
        address ownerCheesePiece,
        uint256 _id_CheesePiece,
        uint256 _quantityToBuy,
        uint256 totalPrice) external {
        
        // Verifica degli address con controlli generici 
        require(msg.sender != address(0), "Invalid sender address");
        require(ownerCheesePiece != address(0), "Invalid owner address");
        require(msg.sender != ownerCheesePiece, "Cannot buy from yourself");
        // Verfica della presenza del Prodotto 
        require(retailerInventoryService.isCheesePiecePresent(ownerCheesePiece, _id_CheesePiece), "Product not found");
        // Verifica della quantità da acquistare rispetto alla quantità totale 
        require(_quantityToBuy <= retailerInventoryService.getWeight(ownerCheesePiece, _id_CheesePiece), "Invalid quantity");
        // Verifica del saldo dell'acquirente 
        require(filieraTokenService.balanceOf(msg.sender) >= totalPrice, "Insufficient balance");

        // Acquisto 
        require(filieraTokenService.transferTokenBuyProduct(msg.sender, ownerCheesePiece, totalPrice),"Acquisto non andato a buon fine!");

        // Aggiornamento del saldo del Retailer
        uint256 newRetailerBalance = filieraTokenService.balanceOf(ownerCheesePiece);
        retailerService.updateRetailerBalance(ownerCheesePiece, newRetailerBalance);
        // Aggiornamento del saldo del Consumer 
        uint256 newConsumerBalance = filieraTokenService.balanceOf(msg.sender);
        consumerService.updateConsumerBalance(msg.sender, newConsumerBalance);

        // Riduzione della quantità nel MilkHubInventory
        uint256 currentQuantity = retailerInventoryService.getWeight(ownerCheesePiece, _id_CheesePiece);
        retailerInventoryService.updateWeight(ownerCheesePiece, _id_CheesePiece, currentQuantity - _quantityToBuy);


        // Aggiunta del MilkBatch nell'inventario del CheeseProducer
        consumerBuyerInventoryService.addCheesePiece(
            ownerCheesePiece,
            msg.sender, 
            _id_CheesePiece,
            retailerInventoryService.getPrice(ownerCheesePiece, _id_CheesePiece),
            _quantityToBuy);
    }


}