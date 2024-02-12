// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;
contract CheeseProducerBuyerInventoryStorage {

    // Address per CheeseProducerOrg 
    address private CheeseProducerOrg;

    constructor() {
        CheeseProducerOrg = msg.sender;
    }

    
    struct CheeseBatch {
        uint256 productId;
        string dop;
        uint256 pricePerKg;
        uint256 quantity; //kg 
    }

    // Mapping dei vari utenti che hanno una lista dei vari MilkBatch 
    mapping(address => mapping(uint256 => CheeseBatch)) private cheeseBatches;


    /**
     * Funzione che permette di aggiungere un determinato CheeseBatch al loro inventario per poterlo rivendere:
     * - 
     */
    function addCheeseBatch(address _cheeseProducer, uint256 _productId, string memory _dop, uint256 _pricePerKg) external {

        cheeseBatches[_cheeseProducer][_productId] = CheeseBatch(_productId, _dop, _pricePerKg);
    }

    function transformAndSell(address _cheeseProducer, uint256 _productId, uint256 _newProductId, uint256 _pricePerKg) external {
        // Assuming transformation logic here, you can implement as needed
        // For simplicity, it's not implemented in this example
        // After transformation, adding to cheeseBatches
        cheeseBatches[_cheeseProducer][_newProductId] = CheeseBatch(_newProductId, "NewDOP", _pricePerKg);
        // Removing the old product
        delete cheeseBatches[_cheeseProducer][_productId];
    }
}