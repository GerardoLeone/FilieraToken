// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;



import "./Actor/Filieratoken.sol";

import "./Actor/MilkHub-smart-contract/inventory/MilkHubInventoryService.sol";
import "./Actor/CheeseProducer-smart-contract/inventory/CheeseProducerMilkBatchService.sol";

contract TransactionManager {

    // FilieraToken Service -> address FilieraToken
    Filieratoken private filieraTokenService;
    // Transaction From CheeseProducer - to - MilkHub
    MilkHubInventoryService private milkhubInventoryService;

    CheeseProducerMilkBatchService private cheeseProducerMilkBatchService;

    constructor(address _milkhubInventoryServiceAddress, address _cheeseProducerMilkBatchServiceAddress, address _filieraToken){

        milkhubInventoryService = MilkHubInventoryService(_milkhubInventoryServiceAddress);
        cheeseProducerMilkBatchService = CheeseProducerMilkBatchService(_cheeseProducerMilkBatchServiceAddress);
        filieraTokenService = Filieratoken(_filieraToken);
    }

    /**
    - Calcolare il prezzo totale dal Front-End e lo passiamo 
    */
    function sellMilkBatchProduct(address ownerMilkBatch, uint256 _id_MilkBatch, uint256 _quantityToBuy, uint256 totalPrice) external {
        // caller 
        address callerCheeseProducer = msg.sender;

        // Check Product in Inventory 
        // True -> possiamo vendere l'oggetto 
        // False -> non possiamo vendere l'oggetto 
        require(milkhubInventoryService.checkProductToSell(ownerMilkBatch,_id_MilkBatch,_quantityToBuy) , "Product to Sell Not valid!");

        // Verifica del balance CheeseProducer 
        // Il saldo deve essere maggiore o uguale del prezzo totale -> prezzo per unità * numero di quantità
        require(filieraTokenService.balanceOf(callerCheeseProducer)>=totalPrice,"Balance not Valid!");

        uint256 balanceOwnerMilkBatch = filieraTokenService.balanceOf(ownerMilkBatch);
        uint256 balanceCallerCheeseProducer = filieraTokenService.balanceOf(callerCheeseProducer);

        // Trasferimento dei soldi 
        // Trasferimento del Total Price 
        filieraTokenService.transferBuyProduct(callerCheeseProducer, ownerMilkBatch, totalPrice);
        // Verifica che il saldo è stato realmente trasferito 
        require(filieraTokenService.balanceOf(callerCheeseProducer)<balanceCallerCheeseProducer,"Sent money not works!");
        require(filieraTokenService.balanceOf(ownerMilkBatch)>balanceOwnerMilkBatch,"Sent Money not works!");


        // Riduzione della quantità nel MilkHubInventory 
        milkhubInventoryService.decreaseMilkBatchQuantity(ownerMilkBatch, _id_MilkBatch, _quantityToBuy);

        // Creazione dell'elemento del MilkBatch all'interno dell'inventory 
        string memory expirationDate = milkhubInventoryService.getExpirationDate(ownerMilkBatch, _id_MilkBatch);
        cheeseProducerMilkBatchService.addMilkBatch(ownerMilkBatch, expirationDate, _quantityToBuy);
    }

}