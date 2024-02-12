// // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CheeseProducerMilkBatchStorage.sol";

contract CheeseProducerMilkBatchService {

    CheeseProducerMilkBatchStorage private cheeseProducerMilkBatchStorage;

    // Address of Organization che gestisce gli utenti
    address private cheeseProducerOrg;

    // Eventi per notificare l'aggiunta di una Partita di Latte
    event CheeseProducerMilkBatchAdded(address indexed userAddress,string message, string expirationDate, uint256 quantity);
    // Eventi per notificare la rimozione di una Partita di Latte
    event CheeseProducerMilkBatchDeleted(address indexed userAddress);
    event CheeseProducerMilkBatchEdited(address indexed userAddress, uint256 quantity);

    constructor(address _cheeseProducerMilkBatchStorage) {
        cheeseProducerMilkBatchStorage = CheeseProducerMilkBatchStorage(_cheeseProducerMilkBatchStorage);
        cheeseProducerOrg = msg.sender;
    }

    function changeCheeseProducerMilkBatchStorage(address _cheeseProducerMilkBatchStorage)external {
        require(msg.sender == cheeseProducerOrg,"Address is not the organization");
        cheeseProducerMilkBatchStorage = CheeseProducerMilkBatchStorage(_cheeseProducerMilkBatchStorage);
    }

    function addMilkBatch(address _walletMilkHub, string memory _expirationDate, uint256 _quantity) external {
        address walletCheeseProducer = msg.sender;

        // Verifico che l'address sia diverso da quello di Deploy 
        require(walletCheeseProducer != cheeseProducerOrg,"Address non Valido!");

        cheeseProducerMilkBatchStorage.addMilkBatch(walletCheeseProducer, _walletMilkHub, _expirationDate, _quantity);

        emit CheeseProducerMilkBatchAdded(walletCheeseProducer,"MilkBatch Acquistato!", _expirationDate, _quantity);
    }


    function getMilkBatch(uint256 _id) external view returns (uint256, address, string memory, uint256) {
        address walletCheeseProducer = msg.sender;

        require(walletCheeseProducer == cheeseProducerOrg, "Address non Valido!");

        return cheeseProducerMilkBatchStorage.getMilkBatch(walletCheeseProducer, _id);
    }

    function decreaseMilkBatchQuantity(uint256 _id, uint256 _quantity) external {
        address walletCheeseProducer = msg.sender;

        require(walletCheeseProducer == cheeseProducerOrg, "Address non Valido!");

        require(cheeseProducerMilkBatchStorage.detractMilkBatchQuantity(walletCheeseProducer, _id, _quantity), "Errore durante la modifica della quantita' di latte nella Partita del Latte");

        emit CheeseProducerMilkBatchEdited(walletCheeseProducer, _quantity);
    }

// -------------------------------------------------- TransactionManager Service ---------------------------------------------------//

}