// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ConsumerInventoryStorage.sol";


contract ConsumerInventoryService {

     // Address of Organization che gestisce gli utenti
    address private  ConsumerOrg;

    ConsumerInventoryStorage private consumerInventoryStorage;

    constructor(address _consumerInventoryStorage){
        ConsumerOrg = msg.sender;
        consumerInventoryStorage = ConsumerInventoryStorage(_consumerInventoryStorage);
    }

    // Eventi per notificare l'aggiunta e l'eliminazione dei dati
    event CheesePieceAdded(address indexed userAddress, string message, string dop, uint256 quantity, uint256 price);
    event CheesePieceDeleted(address indexed userAddress, uint256 indexed id, string message);

    function addCheesePiece(uint256 _id_ref_cheese, string memory _dop, uint256 _quantity, uint256 _price) external {
        address walletConsumer = msg.sender;
        // Verifico che l'address sia diverso da quello di Deploy 
        require(walletConsumer != ConsumerOrg,"Address non Valido!");
        //Call function of Storage 
        consumerInventoryStorage.addCheesePiece(walletConsumer, _id_ref_cheese, _dop, _quantity, _price);
        // Emissione dell'evento 
        emit CheesePieceAdded(walletConsumer, "Pezzo di formaggio inserito !", _dop, _quantity, _price);
    }

    // Get CheesePiece -> address of  
    function getCheesePiece(uint256 _id) external view returns (uint256, string memory, uint256, uint256, uint256) {
        // Retrieve msg.sender 
        address walletConsumer = msg.sender;

        return consumerInventoryStorage.getCheesePiece(walletConsumer,_id);
    }



    // Delete Cheese piece 
    // We can delete a cheese piece with -> address of Consumer and id of CheesePiece
    function deleteCheesePiece(uint256 _id) external returns(bool value) {
        // Retrieve msg.sender 
        address walletConsumer = msg.sender;

        if(consumerInventoryStorage.deleteCheesePiece(walletConsumer,_id)){
            emit CheesePieceDeleted(walletConsumer,_id,"Pezzo di Formaggio e' stato eleminato");
            return true;
        }else {
            return false;
        }
    }
}