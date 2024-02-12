// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CheeseProducerInventoryStorage.sol";

contract CheeseProducerInventoryService {
    // Address dell'organizzazione 
    address private CheeseProducerOrg;
    // Address del contratto di Storage 
    CheeseProducerInventoryStorage private cheeseProducerInventoryStorage;

    constructor(address _cheeseProducerInventoryStorage, address _cheeseProducerOrg) {
        CheeseProducerOrg = _cheeseProducerOrg;
        cheeseProducerInventoryStorage = CheeseProducerInventoryStorage(_cheeseProducerInventoryStorage);
    }

    function addCheeseBatch(uint256 _productId, string memory _dop, uint256 _pricePerKg) external {
        // Recupero il wallet del cheeseProducer
        address walletCheeseProducer = msg.sender;

        cheeseProducerInventoryStorage.addCheeseBatch(walletCheeseProducer, _productId, _dop, _pricePerKg);
    }

    function transformAndSell(uint256 _productId, uint256 _newProductId, uint256 _pricePerKg) external {
        cheeseProducerInventoryStorage.transformAndSell(msg.sender, _productId, _newProductId, _pricePerKg);
    }
}