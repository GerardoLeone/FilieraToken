// SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

import "./Actor/Filieratoken.sol";


// Service 
import "contracts/Actor/CheeseProducer-smart-contract/CheeseProducerService.sol";
import "contracts/Actor/MilkHub-smart-contract/MilkHubService.sol";
import "contracts/Actor/Consumer-smart-contract/ConsumerService.sol";
import "contracts/Actor/Retailer-smart-contract/RetailerService.sol";


// Inventory Service 
import "./Actor/MilkHub-smart-contract/inventory/MilkHubInventoryService.sol";
import "./Actor/CheeseProducer-smart-contract/inventory/CheeseProducerMilkBatchService.sol";

import "contracts/Actor/CheeseProducer-smart-contract/inventory/CheeseProducerInventoryService.sol";
import "contracts/Actor/Retailer-smart-contract/inventory/RetailerCheeseBlockService.sol";



import "contracts/Actor/Retailer-smart-contract/inventory/RetailerInventoryService.sol";
import "contracts/Actor/Consumer-smart-contract/inventory/ConsumerBuyerInventoryService.sol";

contract TransactionManager {

    // FilieraToken Service -> address FilieraToken
    Filieratoken private filieraTokenService;

//---------------------------------------------------------------------------------------- Main Service ----------------------------------------------------------------------------------//    

    // Address of Service of MilkHub 
    MilkHubService private milkhubService;
    // Address of Service of CheeseProducer
    CheeseProducerService private cheeseProducerService;
    // Address of Service of Retailer 
    RetailerService private retailerService;
    // Address of Service of Consumer 
    ConsumerService private consumerService;

//-------------------------------------------------------- Compra Vendita (MilkHub-CheeseProducer) --------------------------------------------------------------------------//


    // Contains -> MilkBatch of MilkHub (Prodotto che viene venduto) 
    //MilkHubInventoryService private milkhubInventoryService;
    // Contains -> MilkBatch of CheeseProducer (Prodotto comprato)  
    //CheeseProducerMilkBatchService private cheeseProducerMilkBatchService;

//-------------------------------------------------------- Compra Vendita (CheeseProducer-Retailer) --------------------------------------------------------------------------//

    // Contains -> Cheese of CheeseProducer (Prodotto che viene venduto)
    //CheeseProducerInventoryService private cheeseProducerInventoryService; 
    // Contains -> Cheese of Retailer (Prodotto comprato) 
    //RetailerCheeseBlockService private retailerCheeseBlockService;


//-------------------------------------------------------- Compra Vendita (Retailer-Consumer) --------------------------------------------------------------------------//

    // Contains -> CheesePiece of Retailer (Prodotto che viene venduto) 
    RetailerInventoryService private retailerInventoryService;
    // Contains -> CheesePiece of Consumer (Prodotto che viene comprato) 
    ConsumerBuyerInventoryService private consumerBuyerInventoryService;




    constructor(
        address _filieraToken,

        //address _milkhubService,
        //address _cheeseProducerService,
        address _retailerService,
        address _consumerService,

        //address _milkhubInventoryServiceAddress,
        //address _cheeseProducerMilkBatchServiceAddress,

        //address _cheeseProducerInventoryService,
        //address _retailerCheeseBlockService,

        address _retailerInventoryService,
        address _consumerBuyerInvenotryService

        ){
        // Filiera Token Service 
        filieraTokenService = Filieratoken(_filieraToken);

        // Main Service 

        //milkhubService = MilkHubService(_milkhubService);
        //cheeseProducerService = CheeseProducerService(_cheeseProducerService);
        
        retailerService = RetailerService(_retailerService);
        consumerService = ConsumerService(_consumerService);

        // Inventory Service 
        //milkhubInventoryService = MilkHubInventoryService(_milkhubInventoryServiceAddress);
        //cheeseProducerMilkBatchService = CheeseProducerMilkBatchService(_cheeseProducerMilkBatchServiceAddress);

        //cheeseProducerInventoryService = CheeseProducerInventoryService(_cheeseProducerInventoryService);
        //retailerCheeseBlockService = RetailerCheeseBlockService(_retailerCheeseBlockService);

        retailerInventoryService = RetailerInventoryService(_retailerInventoryService);
        consumerBuyerInventoryService = ConsumerBuyerInventoryService(_consumerBuyerInventoryService);
    }

    /**
    *
    * Funzione BuyMilkBatchProduct () -> Chiamata dal CheeseProducer 
    *
    */
    /*function BuyMilkBatchProduct(
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
        filieraTokenService.transferBuyProduct(msg.sender, ownerMilkBatch, totalPrice);

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
    }*/




    // Funzione per effettuare una vendita tra CheeseProducer - Retailer 
    /**
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
        filieraTokenService.transferBuyProduct(msg.sender, ownerCheese, totalPrice);

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
    }*/

    
    
    // Acquisto da parte del Consumer -> CheeseProducer 
    // RetailerInventoryService
    // ConsumerBuyerInventoryService
    function BuyCheesePieceProduct(
        address ownerCheesePiece,
        uint256 _id_CheesePiece,
        uint256 _quantityToBuy,
        uint256 totalPrice
    ) external {
        
        // Verifica degli address con controlli generici 
        require(msg.sender != address(0), "Invalid sender address");
        require(ownerCheesePiece != address(0), "Invalid owner address");
        require(msg.sender != ownerCheesePiece, "Cannot buy from yourself");
        // Verfica della presenza del Prodotto 
        require(retailerInventoryService.isCheeseBlockPresent(ownerCheesePiece, _id_Cheese), "Product not found");
        // Verifica della quantità da acquistare rispetto alla quantità totale 
        require(_quantityToBuy <= retailerInventoryService.getCheeseBlockQuantity(ownerCheesePiece, _id_Cheese), "Invalid quantity");
        // Verifica del saldo dell'acquirente 
        require(filieraTokenService.balanceOf(msg.sender) >= totalPrice, "Insufficient balance");

        // Acquisto 
        filieraTokenService.transferBuyProduct(msg.sender, ownerCheesePiece, totalPrice);

        // Aggiornamento del saldo del Retailer
        uint256 newRetailerBalance = filieraTokenService.balanceOf(ownerCheesePiece);
        retailerService.updateCheeseProducerBalance(ownerCheesePiece, newRetailerBalance);
        // Aggiornamento del saldo del Consumer 
        uint256 newConsumerBalance = filieraTokenService.balanceOf(msg.sender);
        consumerService.updateRetailerBalance(msg.sender, newConsumerBalance);

        // Riduzione della quantità nel MilkHubInventory
        uint256 currentQuantity = cheeseProducerInventoryService.getCheeseBlockQuantity(ownerCheesePiece, _id_Cheese);
        retailerInventoryService.updateCheesePieceQuantity(ownerCheesePiece, _id_Cheese, currentQuantity - _quantityToBuy);

        // Aggiunta del MilkBatch nell'inventario del CheeseProducer
        consumerBuyerInventoryService.addCheesePiece(
            ownerCheesePiece,
            msg.sender, 
            _id_Cheese,
            cheeseProducerInventoryService.getDop(ownerCheesePiece, _id_Cheese),
            _quantityToBuy);
    }


}