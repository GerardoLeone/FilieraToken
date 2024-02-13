// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ConsumerInventoryStorage {

     // Address of Organization che gestisce gli utenti
    address private  ConsumerOrg;

    constructor(){
        ConsumerOrg = msg.sender;
    }

    struct CheesePiece {
        uint256 id;
        uint256 quantityTotal;
        uint256 pricePerKg; 
        address walletRetailer;
    }

    
    mapping(address => mapping(uint256 => CheesePiece)) private cheesePieces;


    // Add function to add CheesePiece
    function addCheesePiece(address _walletRetailer,address _walletConsumer, uint256 _quantity, uint256 _price) external {
        // Generazione dell'ID 
        uint256 _id = uint256(keccak256(abi.encodePacked(
            _quantity,
            _price,
            _walletConsumer,
            _walletRetailer
        )));

        require( cheesePieces[_walletConsumer][_id].id == 0, "Pezzo di Formaggio gia' presente!");

        //Crea una nuova Partita di Latte
        CheesePiece memory cheesePiece = CheesePiece({
            id: _id,
            quantityTotal: _quantity,
            pricePerKg: _price,
            walletRetailer:_walletRetailer
        });

        //Inserisce la nuova Partita di Latte nella lista milkBatches
        cheesePieces[_walletConsumer][_id] = cheesePiece;
    }

    // Get CheesePiece -> address of  
    function getCheesePiece(address walletConsumer, uint256 _id) external view returns (uint256, uint256, uint256) {

        require( cheesePieces[walletConsumer][_id].id == _id, "Partita di Latte non presente!");

        CheesePiece memory cheesePiece = cheesePieces[walletConsumer][_id];

        return (cheesePiece.id, cheesePiece.quantityTotal, cheesePiece.pricePerKg);
    }

    function deleteCheesePiece(address walletConsumer, uint256 _id) external returns(bool value) {

        require(cheesePieces[walletConsumer][_id].id != 0, "Partita di Latte non presente!");

        uint256 lastIdMilkBatch = uint256(keccak256(abi.encodePacked(
            cheesePieces[walletConsumer][_id].quantityTotal,
            cheesePieces[walletConsumer][_id].pricePerKg,
            cheesePieces[walletConsumer][_id].walletRetailer,
            walletConsumer
        )));

        require(cheesePieces[walletConsumer][_id].id == lastIdMilkBatch, "Utente non Autorizzato!");
        // Delete piece of Cheese
        delete cheesePieces[walletConsumer][_id];
        // Check CheesePiece in the mapping 
        if(cheesePieces[walletConsumer][_id].id  == 0){
            return true;
        }else {
            return false;
        }
    }
}