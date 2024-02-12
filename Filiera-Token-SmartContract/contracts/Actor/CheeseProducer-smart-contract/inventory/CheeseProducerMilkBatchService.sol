// // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CheeseProducerMilkBatchStorage.sol";

contract CheeseProducerMilkBatchService {

    CheeseProducerMilkBatchStorage private cheeseProducerMilkBatchStorage;

    // Address of Organization che gestisce gli utenti
    address private cheeseProducerOrg;

    // Eventi per notificare l'aggiunta di una Partita di Latte
    event CheeseProducerMilkBatchAdded(address indexed userAddress, string expirationDate, uint256 quantity);

    // Eventi per notificare la rimozione di una Partita di Latte
    event CheeseProducerMilkBatchDeleted(address indexed userAddress);

    event CheeseProducerMilkBatchEdited(address indexed userAddress, uint256 quantity);

    constructor(address _cheeseProducerMilkBatchStorage) {
        cheeseProducerMilkBatchStorage = CheeseProducerMilkBatchStorage(_cheeseProducerMilkBatchStorage);
        cheeseProducerOrg = msg.sender;
    }

    function insertMilkBatch(address _walletMilkHub, string memory _expirationDate, uint256 _quantity) external {
        // Verifico che l'address sia diverso da quello di Deploy 
        require(msg.sender == cheeseProducerOrg,"Address non Valido!");

        cheeseProducerMilkBatchStorage.addMilkBatch(msg.sender, _walletMilkHub, _expirationDate, _quantity);

        emit CheeseProducerMilkBatchAdded(msg.sender, _expirationDate, _quantity);
    }

    function fetchMilkBatch(uint256 _id) external view returns (uint256, address, string memory, uint256) {
        address walletCheeseProducer = msg.sender;

        require(walletCheeseProducer == cheeseProducerOrg, "Address non Valido!");

        return cheeseProducerMilkBatchStorage.getMilkBatch(walletCheeseProducer, _id);
    }

    function removeMilkBatch(uint256 _id) external {
        address walletCheeseProducer = msg.sender;
        
        require(walletCheeseProducer == cheeseProducerOrg, "Address non Valido!");

        require(cheeseProducerMilkBatchStorage.deleteMilkBatch(walletCheeseProducer, _id), "Errore durante la cancellazione");

        emit CheeseProducerMilkBatchDeleted(walletCheeseProducer);
    }

    function decreaseMilkBatchQuantity(uint256 _id, uint256 _quantity) external {
        address walletCheeseProducer = msg.sender;

        require(walletCheeseProducer == cheeseProducerOrg, "Address non Valido!");

        require(cheeseProducerMilkBatchStorage.detractMilkBatchQuantity(walletCheeseProducer, _id, _quantity), "Errore durante la modifica della quantita' di latte nella Partita del Latte");

        emit CheeseProducerMilkBatchEdited(walletCheeseProducer, _quantity);
    }
}