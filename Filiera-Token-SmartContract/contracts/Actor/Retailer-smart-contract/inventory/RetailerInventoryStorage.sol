// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RetailerInventoryStorage {

    // Address of the organization managing the users
    address private retailerOrg;

    constructor() {
        retailerOrg = msg.sender;
    }

    struct CheesePiece {
        uint256 id; // Cheese Piece ID 
        uint256 price;
        uint256 weight;
    }

    mapping(address => mapping(uint256 => CheesePiece)) private cheesePieces;

    // --------------------------------------------------- Business Function --------------------------------------------------------------------------------------//

    function addCheesePiece(
        address walletRetailer,
        uint256 _id_CheeseBlock,
        uint256 _price,
        uint256 _weight
    ) external returns (uint256, uint256, uint256) {

        uint256 _id = uint256(keccak256(abi.encodePacked(
            _id_CheeseBlock,
            _price,
            _weight,
            walletRetailer
        )));

        // Verifico che non sia stata già registrata questo pezzo di formaggio 
        require(cheesePieces[walletRetailer][_id].id == 0, "Pezzo di formaggio gia' presente!");

        // Crea un nuovo Pezzo di formaggio
        CheesePiece memory cheesePiece = CheesePiece({
            id: _id,
            price: _price,
            weight: _weight
        });

        // Inserisce il nuovo Pezzo di formaggio nella lista cheesePieces
        cheesePieces[walletRetailer][_id] = cheesePiece;

        return (cheesePiece.id, cheesePiece.price, cheesePiece.weight);
    }

    function getCheesePiece(address walletRetailer, uint256 _id) external view returns (uint256, uint256, uint256) {

        CheesePiece memory cheesePiece = cheesePieces[walletRetailer][_id];

        return (cheesePiece.id, cheesePiece.price, cheesePiece.weight);
    }

    // Elimina il CheesePiece 
    function deleteCheesePiece(address walletRetailer, uint256 _id) external returns (bool value) {

        delete cheesePieces[walletRetailer][_id];
        // Check CheesePiece in the mapping 
        if (cheesePieces[walletRetailer][_id].id == 0) {
            return true;
        } else {
            return false;
        }
    }

    // Verifica che il CheesePiece è già presente 
    function isCheesePiecePresent(address walletRetailer, uint256 _id_CheesePiece) external view returns (bool) {

        require(_id_CheesePiece != 0 && _id_CheesePiece > 0, "ID CheesePiece Non Valido!");

        return cheesePieces[walletRetailer][_id_CheesePiece].id == _id_CheesePiece;
    }

    // --------------------------------------------------- Get Function --------------------------------------------------------------------------------------//

    function getPrice(address walletRetailer, uint256 _id) external view returns (uint256) {

        CheesePiece memory cheesePiece = cheesePieces[walletRetailer][_id];
        return cheesePiece.price;
    }

    function getWeight(address walletRetailer, uint256 _id) external view returns (uint256) {

        CheesePiece memory cheesePiece = cheesePieces[walletRetailer][_id];
        return cheesePiece.weight;
    }
}
