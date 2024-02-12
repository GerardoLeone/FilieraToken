// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MilkHubInventoryStorage {

     // Address of Organization che gestisce gli utenti
    address private  MilkHubOrg;

    constructor(){
        MilkHubOrg = msg.sender;
    }

    struct MilkBatch {
        uint256 id;
        string scadenza;
        uint256 quantity; 
        uint256 price; // Prezzo di vendita per un Litro di  ( Partita di Latte )
    }

    
    mapping(address => mapping(uint256 => MilkBatch)) private milkBatches;

    // Add function to add CheesePiece
    function addMilkBatch(address walletMilkHub, string memory _scadenza, uint256 _quantity, uint256 _price) external {
        // Generazione dell'ID 
        uint256 _id = uint256(keccak256(abi.encodePacked(
            _scadenza,
            _quantity,
            _price,
            walletMilkHub
        )));

        require( milkBatches[walletMilkHub][_id].id == 0, "Pezzo di Formaggio gia' presente!");

        //Crea una nuova Partita di Latte
        MilkBatch memory milkBatch = MilkBatch({
            id: _id,
            scadenza: _scadenza,
            quantity: _quantity,
            price: _price
        });

        //Inserisce la nuova Partita di Latte nella lista milkBatches
        milkBatches[walletMilkHub][_id] = milkBatch;
    }

    // Get CheesePiece -> address of  
    function getMilkBatch(address walletMilkHub, uint256 _id) external view returns (uint256, string memory, uint256, uint256) {

        require( milkBatches[walletMilkHub][_id].id != 0, "Partita di Latte non presente!");

        MilkBatch memory milkBatch = milkBatches[walletMilkHub][_id];

        return (milkBatch.id, milkBatch.scadenza, milkBatch.quantity, milkBatch.price);
    }

    // Delete Cheese piece 
    // We can delete a cheese piece with -> address of Consumer and id of CheesePiece
    function deleteMilkBatch(address walletMilkHub, uint256 _id) external returns(bool value) {

        require(milkBatches[walletMilkHub][_id].id != 0, "Partita di Latte non presente!");

        uint256 lastIdMilkBatch = uint256(keccak256(abi.encodePacked(
            milkBatches[walletMilkHub][_id].scadenza,
            milkBatches[walletMilkHub][_id].quantity,
            milkBatches[walletMilkHub][_id].price,
            walletMilkHub
        )));

        require(milkBatches[walletMilkHub][_id].id == lastIdMilkBatch, "Utente non Autorizzato!");
        // Delete piece of Cheese
        delete milkBatches[walletMilkHub][_id];
        // Check CheesePiece in the mapping 
        if(milkBatches[walletMilkHub][_id].id  == 0){
            return true;
        }else {
            return false;
        }
    }
}