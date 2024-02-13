// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//Smart Contract per lo storage dei MilkHub acquistati dal CheeseProducer
contract CheeseProducerMilkBatchStorage {

    // Address of Organization che gestisce gli utenti
    address private cheeseProducerOrg;

    constructor() {
        cheeseProducerOrg = msg.sender;
    }

    struct MilkBatch {
        uint256 id;
        address walletMilkHub;
        string expirationDate;
        uint256 quantity;
    }

    mapping(address => mapping(uint256 => MilkBatch)) private purchasedMilkBatches;

    function addMilkBatch(address _walletCheeseProducer,address _walletMilkHub,string memory _expirationDate,uint256 _quantity) external {

        uint256 _id = uint256(keccak256(abi.encodePacked(
            _expirationDate,
            _quantity,
            _walletCheeseProducer,
            _walletMilkHub
        )));

        MilkBatch storage milkbatchControl = purchasedMilkBatches[_walletCheeseProducer][_id];
        require( milkbatchControl.id == 0, "Partita di Latte gia' presente!");

        //Crea una nuova Partita di Latte
        MilkBatch memory milkBatch = MilkBatch({
            id: _id,
            walletMilkHub: _walletMilkHub,
            expirationDate: _expirationDate,
            quantity: _quantity
        });

        //Inserisce la nuova Partita di Latte nella lista milkBatches
        purchasedMilkBatches[_walletCheeseProducer][_id] = milkBatch;
    }



    function getMilkBatch(address walletCheeseProducer, uint256 _id) external view returns (uint256, address, string memory, uint256) {

        require( purchasedMilkBatches[walletCheeseProducer][_id].id == _id, "Partita di Latte non presente!");

        MilkBatch memory milkBatch = purchasedMilkBatches[walletCheeseProducer][_id];

        return (milkBatch.id, milkBatch.walletMilkHub, milkBatch.expirationDate, milkBatch.quantity);
    }




    function deleteMilkBatch(address walletCheeseProducer, uint256 _id) external returns(bool value) {

        require(purchasedMilkBatches[walletCheeseProducer][_id].id != 0, "Partita di Latte non presente!");

        uint256 lastIdMilkBatch = uint256(keccak256(abi.encodePacked(
            purchasedMilkBatches[walletCheeseProducer][_id].expirationDate,
            purchasedMilkBatches[walletCheeseProducer][_id].quantity,
            purchasedMilkBatches[walletCheeseProducer][_id].walletMilkHub,
            walletCheeseProducer
        )));

        require(purchasedMilkBatches[walletCheeseProducer][_id].id == lastIdMilkBatch, "Utente non Autorizzato!");

        delete purchasedMilkBatches[walletCheeseProducer][_id];

        // Check CheesePiece in the mapping 
        if(purchasedMilkBatches[walletCheeseProducer][_id].id  == 0){
            return true;
        }else {
            return false;
        }
    }




    function detractMilkBatchQuantity(address walletCheeseProducer, uint256 _id, uint256 _quantity) external returns(bool value) {

        require(purchasedMilkBatches[walletCheeseProducer][_id].id != 0, "Partita di Latte non presente!");

        require(purchasedMilkBatches[walletCheeseProducer][_id].quantity >= _quantity, "Quantita' inserita non disponibile!");

        purchasedMilkBatches[walletCheeseProducer][_id].quantity = purchasedMilkBatches[walletCheeseProducer][_id].quantity - _quantity;

        return true;
    }

    function getExpirationDate(address walletCheeseProducer, uint256 _id) external view returns(string memory) {
        require(purchasedMilkBatches[walletCheeseProducer][_id].id != 0, "Partita di Latte non presente!");

        MilkBatch memory milkBatch = purchasedMilkBatches[walletCheeseProducer][_id];
        return milkBatch.expirationDate;
    }

    function getQuantity(address walletCheeseProducer, uint256 _id) external view returns(uint256) {
        require(purchasedMilkBatches[walletCheeseProducer][_id].id != 0, "Partita di Latte non presente!");

        MilkBatch memory milkBatch = purchasedMilkBatches[walletCheeseProducer][_id];
        return milkBatch.quantity;        
    }

    function getWalletMilkHub(address walletCheeseProducer, uint256 _id) external view returns(address) {
        require(purchasedMilkBatches[walletCheeseProducer][_id].id != 0, "Partita di Latte non presente!");

        MilkBatch memory milkBatch = purchasedMilkBatches[walletCheeseProducer][_id];
        return milkBatch.walletMilkHub;
    }

    function getId(address walletCheeseProducer, uint256 _id) external view returns(uint256) {
        require(purchasedMilkBatches[walletCheeseProducer][_id].id != 0, "Partita di Latte non presente!");

        return purchasedMilkBatches[walletCheeseProducer][_id].id;
    }

    function checkMilkBatch(address walletCheeseProducer, uint256 _id, uint256 _quantityToTransform) external view returns(bool) {
        require(purchasedMilkBatches[walletCheeseProducer][_id].id == _id, "Partita di Latte non presente!");

        MilkBatch storage milkBatchObj = purchasedMilkBatches[walletCheeseProducer][_id];
            
        require(milkBatchObj.quantity >= _quantityToTransform, "Quantity not Valid!");
        return true;    
    }

    
}