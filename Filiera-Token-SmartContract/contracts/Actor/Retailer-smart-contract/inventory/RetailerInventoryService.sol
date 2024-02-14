// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./RetailerInventoryStorage.sol";
import "../RetailerService.sol";
import "./RetailerCheeseBlockService.sol";

contract RetailerInventoryService {

    // Address of the organization managing the users
    address private retailerOrg;

    RetailerInventoryStorage private retailerInventoryStorage;

    RetailerService private retailerService;

    RetailerCheeseBlockService private retailerCheeseBlockService;

    event CheesePieceAdded(address indexed userAddress, string message, uint256 id, uint256 price, uint256 weight);

    event CheesePieceDeleted(address indexed userAddress, string message, uint256 _id);

    event CheesePieceEdited(address indexed userAddress, string message, uint256 weight);

    modifier checkAddress(address caller) {
        require(caller != address(0), "Address Value is Zero!");
        require(caller != retailerOrg, "Address not valid!");
        require(caller != address(retailerInventoryStorage), "Address not valid of Inventory Storage");
        require(caller != address(retailerService), "Address not valid of Service");
        _;
    }

    constructor(
        address _retailerInventoryStorage,
        address _retailerService,
        address _retailerCheeseBlockService
    ) {
        retailerInventoryStorage = RetailerInventoryStorage(_retailerInventoryStorage);
        retailerService = RetailerService(_retailerService);
        retailerCheeseBlockService = RetailerCheeseBlockService(_retailerCheeseBlockService);
        retailerOrg = msg.sender;
    }

    function addCheesePiece(
        address _walletRetailer,
        uint256 _id_CheeseBlockAcquistato,
        uint256 _price,
        uint256 _weight
    ) internal checkAddress(_walletRetailer) {
        require(retailerService.isUserPresent(_walletRetailer), "User is not present in data");

        (uint256 id_CheesePiece, uint256 price, uint256 weight) = retailerInventoryStorage.addCheesePiece(
            _walletRetailer,
            _id_CheeseBlockAcquistato,
            _price,
            _weight
        );

        emit CheesePieceAdded(_walletRetailer, "CheeseBlock convertito con successo! Ecco il nuovo CheesePiece!", id_CheesePiece, price, weight);
    }

    function getCheesePiece(uint256 _id_CheesePiece) external view checkAddress(msg.sender) returns (uint256, uint256, uint256) {
        address walletRetailer = msg.sender;

        require(retailerService.isUserPresent(walletRetailer), "User is not present in data");

        require(this.isCheesePiecePresent(walletRetailer, _id_CheesePiece), "CheesePiece is not present in data");

        return retailerInventoryStorage.getCheesePiece(walletRetailer, _id_CheesePiece);
    }

    function deleteCheesePiece(uint256 _id) external returns (bool) {
        address walletRetailer = msg.sender;

        require(retailerService.isUserPresent(walletRetailer), "User is not present!");

        require(this.isCheesePiecePresent(walletRetailer, _id), "CheesePiece not Present!");

        if (retailerInventoryStorage.deleteCheesePiece(walletRetailer, _id)) {
            emit CheesePieceDeleted(walletRetailer, "CheesePiece e' stato eliminato", _id);
            return true;
        } else {
            return false;
        }
    }

    function getPrice(address walletRetailer, uint256 _id) external view returns (uint256) {
        require(retailerService.isUserPresent(walletRetailer), "User is not present!");

        require(this.isCheesePiecePresent(walletRetailer, _id), "CheesePiece not Present!");

        return retailerInventoryStorage.getPrice(walletRetailer, _id);
    }

    function getWeight(address walletRetailer, uint256 _id) external view returns (uint256) {
        require(retailerService.isUserPresent(walletRetailer), "User is not present!");

        require(this.isCheesePiecePresent(walletRetailer, _id), "CheesePiece not Present!");

        return retailerInventoryStorage.getWeight(walletRetailer, _id);
    }

    function isCheesePiecePresent(address walletRetailer, uint256 _id_cheesePiece) external view checkAddress(walletRetailer) returns (bool) {
        return retailerInventoryStorage.isCheesePiecePresent(walletRetailer, _id_cheesePiece);
    }

    function updateWeight(address ownerRetailer, uint256 _id, uint256 _weight) external checkAddress(ownerRetailer) {
        require(retailerService.isUserPresent(ownerRetailer), "User is not present!");

        require(this.isCheesePiecePresent(ownerRetailer, _id), "CheesePiece not Present!");

        retailerInventoryStorage.updateCheesePieceWeight(ownerRetailer, _id, _weight);

        emit CheesePieceEdited(ownerRetailer, "CheesePiece edited!", _weight);
    }

    function transformCheeseBlock(address walletRetailer, uint256 _id_CheeseBlockAcquistato, uint256 quantityToTransform, uint256 price)
        external
    {
        require(retailerCheeseBlockService.isCheeseBlockAcquistataPresent(walletRetailer, _id_CheeseBlockAcquistato), "Prodotto non presente!");

        require(quantityToTransform <= 3, "Quantita' da trasformare non valida!");

        require(quantityToTransform <= retailerCheeseBlockService.getQuantity(walletRetailer, _id_CheeseBlockAcquistato), "Quantita' da trasformare non valida!");

        uint256 newQuantity = retailerCheeseBlockService.getQuantity(walletRetailer, _id_CheeseBlockAcquistato) - quantityToTransform;

        retailerCheeseBlockService.updateCheeseBlockQuantity(walletRetailer, _id_CheeseBlockAcquistato, newQuantity);

        addCheesePiece(walletRetailer, _id_CheeseBlockAcquistato, price, quantityToTransform);
    }
}
