// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CheeseProducerInventoryStorage.sol";

contract CheeseProducerInventoryService {

    // Address of Consumer Storage 
    CheeseProducerInventoryStorage private cheeseProducerInventoryStorage;

    // Address of Organization che gestisce gli utenti
    address private cheeseProducerOrg;

    // Eventi per notificare l'aggiunta di una Partita di Latte
    event CheeseBlockAdded(address indexed userAddress, string dop, uint256 quantity, uint256 price);

    // Eventi per notificare la rimozione di una Partita di Latte
    event CheeseBlockDeleted(address indexed userAddress);

    constructor(address _cheeseProducerInventoryStorage) {
        cheeseProducerInventoryStorage = CheeseProducerInventoryStorage(_cheeseProducerInventoryStorage);
        cheeseProducerOrg = msg.sender;
    }

    function insertCheeseBlock(string memory _dop, uint256 _quantity, uint256 _price) external {
        // Verifico che l'address sia diverso da quello di Deploy 
        require(msg.sender == cheeseProducerOrg, "Address non Valido!");

        cheeseProducerInventoryStorage.addCheeseBlock(msg.sender, _dop, _quantity, _price);

        emit CheeseBlockAdded(msg.sender, _dop, _quantity, _price);
    }

    function fetchCheeseBlock(uint256 _id) external view returns (uint256, string memory, uint256, uint256) {
        address walletCheeseProducer = msg.sender;

        require(walletCheeseProducer == cheeseProducerOrg, "Address non Valido!");

        return cheeseProducerInventoryStorage.getCheeseBlock(walletCheeseProducer, _id);
    }

    function removeCheeseBlock(uint256 _id) external {
        address walletCheeseProducer = msg.sender;
        
        require(walletCheeseProducer == cheeseProducerOrg, "Address non Valido!");

        require(cheeseProducerInventoryStorage.deleteCheeseBlock(walletCheeseProducer, _id), "Errore durante la cancellazione");

        emit CheeseBlockDeleted(walletCheeseProducer);
    }
}
