//SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

import "contracts/Actor/CheeseProducer-smart-contract/CheeseProducerService.sol";
import "contracts/Actor/Consumer-smart-contract/ConsumerService.sol";
import "contracts/Actor/Retailer-smart-contract/RetailerService.sol";

contract AccessControlProduct{

    CheeseProucerService private cheeseProducerService;

    RetailerService private retailerService;

    ConsumerService private consumerService;

    constructor(
        address _cheeseProducerService,
        address _retailerService,
        address _consumerService
    ){
        cheeseProucerService = CheeseProducerService(_cheeseProducerService);
        retailerService = RetailerService(_retailerService);
        consumerService = ConsumerService(_consumerService);
    }


    function checkViewMilkBatchProduct(address walletCheeseProducer)view returns (bool){
        require(cheeseProducerService.isUserPresent(walletCheeseProducer),"Utente non autorizzato!");
        return true;
    }
    
    function checkViewCheeseBlockProduct(address walletRetailer)view returns (bool){
        require(retailerService.isUserPresent(walletRetailer),"Utente non autorizzato!");
        return true;
    }

    function checkViewCheesePieceProduct(address walletConsumer)view returns (bool){
        require(consumerService.isUserPresent(walletConsumer),"Utente non autorizzato!");
        return true;
    }
}