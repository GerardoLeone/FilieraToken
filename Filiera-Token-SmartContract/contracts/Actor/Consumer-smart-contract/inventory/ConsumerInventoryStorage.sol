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
        string dop;
        uint256 quantity;
        uint256 price;
        uint256 id_cheesePiece_ref; // Riferimento al prodotto acquistato dal Consumer 
        // Acquistando questo pezzo -> possiamo prendere in considerazione l'ID del cheesePiece acquistato e metterlo all'interno dell'inventory del Consumer 
        // Si fa risultare come prodotto di checkout 
    }

    
    mapping(address => mapping(uint256 => CheesePiece)) private cheesePieces;


    // Add function to add CheesePiece
    function addCheesePiece(address walletConsumer,uint256 id_cheesePiece_ref, string memory _dop, uint256 _quantity, uint256 _price) external {
        // Generazione dell'ID 
        uint256 _id = uint256(keccak256(abi.encodePacked(
            _dop,
            _quantity,
            _price,
            id_cheesePiece_ref,
            walletConsumer
        )));

        require( cheesePieces[walletConsumer][_id].id == 0, "Pezzo di Formaggio gia' presente!");

        //Crea una nuova Partita di Latte
        CheesePiece memory cheesePiece = CheesePiece({
            id: _id,
            dop: _dop,
            quantity: _quantity,
            price: _price,
            id_cheesePiece_ref:id_cheesePiece_ref
        });

        //Inserisce la nuova Partita di Latte nella lista milkBatches
        cheesePieces[walletConsumer][_id] = cheesePiece;
    }

    // Get CheesePiece -> address of  
    function getCheesePiece(address walletConsumer, uint256 _id) external view returns (uint256, string memory, uint256, uint256, uint256) {

        require( cheesePieces[walletConsumer][_id].id != 0, "Partita di Latte non presente!");

        CheesePiece memory cheesePiece = cheesePieces[walletConsumer][_id];

        return (cheesePiece.id, cheesePiece.dop, cheesePiece.quantity, cheesePiece.price, cheesePiece.id_cheesePiece_ref);
    }

    // Delete Cheese piece 
    // We can delete a cheese piece with -> address of Consumer and id of CheesePiece
    function deleteCheesePiece(address walletConsumer, uint256 _id) external returns(bool value) {

        require(cheesePieces[walletConsumer][_id].id != 0, "Partita di Latte non presente!");

        uint256 lastIdMilkBatch = uint256(keccak256(abi.encodePacked(
            cheesePieces[walletConsumer][_id].dop,
            cheesePieces[walletConsumer][_id].quantity,
            cheesePieces[walletConsumer][_id].price,
            cheesePieces[walletConsumer][_id].id_cheesePiece_ref,
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