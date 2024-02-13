// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CheeseProducerInventoryStorage {

    // Address of Organization che gestisce gli utenti
    address private cheeseProducerOrg;

    constructor() {
        cheeseProducerOrg = msg.sender;
    }

    struct Cheese {
        uint256 id;
        string dop;
        uint256 price;
        uint256 quantity;
    }

    mapping(address => mapping(uint256 => Cheese)) private cheeseBlocks;

    function addCheeseBlock(address walletCheeseProducer, string memory _dop, uint256 _price, uint256 _quantity) external {

        uint256 _id = uint256(keccak256(abi.encodePacked(
            _dop,
            _price,
            _quantity,
            walletCheeseProducer
        )));

        require(cheeseBlocks[walletCheeseProducer][_id].id == 0, "Blocco di formaggio gia' presente!");

        // Crea un nuovo Blocco di formaggio
        Cheese memory cheeseBlock = Cheese({
            id: _id,
            dop: _dop,
            price: _price,
            quantity: _quantity
        });

        // Inserisce il nuovo Blocco di formaggio nella lista cheeseBlocks
        cheeseBlocks[walletCheeseProducer][_id] = cheeseBlock;
    }

    function getCheeseBlock(address walletCheeseProducer, uint256 _id) external view returns (uint256, string memory, uint256, uint256) {

        require(cheeseBlocks[walletCheeseProducer][_id].id != 0, "Blocco di formaggio non presente!");

        Cheese memory cheeseBlock = cheeseBlocks[walletCheeseProducer][_id];

        return (cheeseBlock.id, cheeseBlock.dop, cheeseBlock.price, cheeseBlock.quantity);
    }

    function deleteCheeseBlock(address walletCheeseProducer, uint256 _id) external returns(bool value) {

        require(cheeseBlocks[walletCheeseProducer][_id].id != 0, "Blocco di formaggio non presente!");

        uint256 lastIdCheeseBlock = uint256(keccak256(abi.encodePacked(
            cheeseBlocks[walletCheeseProducer][_id].dop,
            cheeseBlocks[walletCheeseProducer][_id].price,
            cheeseBlocks[walletCheeseProducer][_id].quantity,
            walletCheeseProducer
        )));

        require(cheeseBlocks[walletCheeseProducer][_id].id == lastIdCheeseBlock, "Utente non Autorizzato!");

        delete cheeseBlocks[walletCheeseProducer][_id];

        return true;
    }

    function getDop(address walletCheeseProducer, uint256 _id) external view returns(string memory) {
        require(cheeseBlocks[walletCheeseProducer][_id].id != 0, "Blocco di formaggio non presente!");

        Cheese memory cheeseBlock = cheeseBlocks[walletCheeseProducer][_id];
        return cheeseBlock.dop;
    }

    function getPrice(address walletCheeseProducer, uint256 _id) external view returns(uint256) {
        require(cheeseBlocks[walletCheeseProducer][_id].id != 0, "Blocco di formaggio non presente!");

        Cheese memory cheeseBlock = cheeseBlocks[walletCheeseProducer][_id];
        return cheeseBlock.price;
    }

    function getQuantity(address walletCheeseProducer, uint256 _id) external view returns(uint256) {
        require(cheeseBlocks[walletCheeseProducer][_id].id != 0, "Blocco di formaggio non presente!");

        Cheese memory cheeseBlock = cheeseBlocks[walletCheeseProducer][_id];
        return cheeseBlock.quantity;
    }
}
