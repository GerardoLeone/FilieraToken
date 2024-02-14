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

//import "contracts/Actor/CheeseProducer-smart-contract/inventory/CheeseProducerInventoryService.sol";
//import "contracts/Actor/Retailer-smart-contract/inventory/RetailerBuyerInventoryService.sol";



//import "contracts/Actor/Retailer-smart-contract/inventory/RetailerInventoryService.sol";
//import "contracts/Actor/Consumer-smart-contract/inventory/ConsumerInventoryService.sol";

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
    MilkHubInventoryService private milkhubInventoryService;
    // Contains -> MilkBatch of CheeseProducer (Prodotto comprato)  
    CheeseProducerMilkBatchService private cheeseProducerMilkBatchService;

//-------------------------------------------------------- Compra Vendita (CheeseProducer-Retailer) --------------------------------------------------------------------------//

    // Contains -> Cheese of CheeseProducer (Prodotto che viene venduto)
    //CheeseProducerInventoryService private cheeseProducerInventoryService; 
    // Contains -> Cheese of Retailer (Prodotto comprato) 
    //RetailerBuyerInventoryService private retailerBuyerInventoryService;


//-------------------------------------------------------- Compra Vendita (Retailer-Consumer) --------------------------------------------------------------------------//

    // Contains -> CheesePiece of Retailer (Prodotto che viene venduto) 
    //RetailerInventoryService private retailerInventoryService;
    // Contains -> CheesePiece of Consumer (Prodotto che viene comprato) 
    //ConsumerInventoryService private consumerInventoryService;




    constructor(
        address _milkhubInventoryServiceAddress,
        address _cheeseProducerMilkBatchServiceAddress,
        address _filieraToken,

        address _milkhubService,
        address _cheeseProducerService
        //address _retailerService,
        //address _consumerService
        ){
        
        filieraTokenService = Filieratoken(_filieraToken);

        // Main Service 
        milkhubService = MilkHubService(_milkhubService);
        cheeseProducerService = CheeseProducerService(_cheeseProducerService);
        //retailerService = RetailerService(_retailerService);
        //consumerService = ConsumerService(_consumerService);

        // Inventory Service 
        milkhubInventoryService = MilkHubInventoryService(_milkhubInventoryServiceAddress);
        cheeseProducerMilkBatchService = CheeseProducerMilkBatchService(_cheeseProducerMilkBatchServiceAddress);
    }

    /**
    *
    * Funzione BuyMilkBatchProduct () -> Chiamata dal CheeseProducer 
    *
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
    }




    // Funzione per effettuare una vendita tra CheeseProducer - Retailer 
    /*
    function sellCheeseProduct(address ownerCheese, uint256 _id_Cheese, uint256 _quantityToBuy, uint256 totalPrice) external {
        // caller 
        address callerRetailer = msg.sender;

        require(callerRetailer!=ownerCheese,"Address of owner and Address of spender are same!");
        // Check User in CheeseProducer - Retailer 

        // Check Product in Inventory 
        // True -> possiamo vendere l'oggetto 
        // False -> non possiamo vendere l'oggetto 
        require(milkhubInventoryService.checkProductToSell(ownerCheese,_id_Cheese,_quantityToBuy) , "Product to Sell Not valid!");

        // Verifica del balance CheeseProducer 
        // Il saldo deve essere maggiore o uguale del prezzo totale -> prezzo per unità * numero di quantità
        require(filieraTokenService.balanceOf(callerRetailer)>=totalPrice,"Balance not Valid!");

        uint256 balanceOwnerMilkBatch = filieraTokenService.balanceOf(ownerCheese);
        uint256 balanceCallerCheeseProducer = filieraTokenService.balanceOf(callerRetailer);

        // Trasferimento dei soldi 
        // Trasferimento del Total Price 
        filieraTokenService.transferBuyProduct(callerRetailer, ownerCheese, totalPrice);
        // Verifica che il saldo è stato realmente trasferito 
        require(filieraTokenService.balanceOf(callerRetailer)<balanceCallerCheeseProducer,"Sent money not works!");
        require(filieraTokenService.balanceOf(ownerCheese)>balanceOwnerMilkBatch,"Sent Money not works!");
        //Update Balance of CheeseProducer and MilkHub 


        // Riduzione della quantità nel MilkHubInventory 
        milkhubInventoryService.updateMilkBatchQuantity(ownerCheese,_id_Cheese , _quantityToBuy);

        // Creazione dell'elemento del MilkBatch all'interno dell'inventory 
        string memory expirationDate = milkhubInventoryService.getMilkBatchExpirationDate(ownerCheese, _id_Cheese);
        //cheeseProducerMilkBatchService.addMilkBatch(ownerCheese, expirationDate, _quantityToBuy); 
    }*/
    /*
    function sellCheesePieceProduct(address ownerCheesePiece, uint256 _id_CheesePiece, uint256 _quantityToBuy, uint256 totalPrice) external {
        // caller 
        address callerConsumer = msg.sender;

        require(callerConsumer!= ownerCheesePiece,"Address of owner and Address of spender are same!");
        // Check User in CheeseProducer - Retailer 

        // Check Product in Inventory 
        // True -> possiamo vendere l'oggetto 
        // False -> non possiamo vendere l'oggetto 
        require(milkhubInventoryService.checkProductToSell(ownerCheesePiece,_id_CheesePiece,_quantityToBuy) , "Product to Sell Not valid!");

        // Verifica del balance CheeseProducer 
        // Il saldo deve essere maggiore o uguale del prezzo totale -> prezzo per unità * numero di quantità
        require(filieraTokenService.balanceOf(callerConsumer)>=totalPrice,"Balance not Valid!");

        uint256 balanceownerCheesePiece = filieraTokenService.balanceOf(ownerCheesePiece);
        uint256 balancecallerConsumer = filieraTokenService.balanceOf(callerConsumer);

        // Trasferimento dei soldi 
        // Trasferimento del Total Price 
        filieraTokenService.transferBuyProduct(callerConsumer, ownerCheesePiece, totalPrice);
        // Verifica che il saldo è stato realmente trasferito 
        require(filieraTokenService.balanceOf(callerConsumer)<balancecallerConsumer,"Sent money not works!");
        require(filieraTokenService.balanceOf(ownerCheesePiece)>balanceownerCheesePiece,"Sent Money not works!");
        //Update Balance of CheeseProducer and MilkHub 


        // Riduzione della quantità nel MilkHubInventory 
        milkhubInventoryService.updateMilkBatchQuantity(ownerCheesePiece, _id_CheesePiece, _quantityToBuy);

        // Creazione dell'elemento del MilkBatch all'interno dell'inventory 
        string memory expirationDate = milkhubInventoryService.getMilkBatchExpirationDate(ownerCheesePiece, _id_CheesePiece);
        //cheeseProducerMilkBatchService.addMilkBatch(ownerCheesePiece, expirationDate, _quantityToBuy); 
    }*/


}