// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MilkHubInventoryStorage.sol";


contract MilkHubInventoryService {

     // Address of Organization che gestisce gli utenti
    address private  MilkHubOrg;

    MilkHubInventoryStorage private milkhubInventoryStorage;

    constructor(address _milkhubInventoryStorage){
        MilkHubOrg = msg.sender;
        milkhubInventoryStorage = MilkHubInventoryStorage(_milkhubInventoryStorage);
    }

    // Eventi per notificare l'aggiunta e l'eliminazione dei dati
    event MilkBatchAdded(address indexed userAddress, string message, string dop, uint256 quantity, uint256 price);
    event MilkBatchDeleted(address indexed userAddress, uint256 indexed id, string message);

    function addMilkBatch(string memory _scadenza, uint256 _quantity, uint256 _price) external {
        address walletMilkHub = msg.sender;
        // Verifico che l'address sia diverso da quello di Deploy 
        require(walletMilkHub != ConsumerOrg,"Address non Valido!");
        //Call function of Storage 
        milkhubInventoryStorage.addMilkBatch(walletMilkHub, _scadenza, _quantity, _price);
        // Emissione dell'evento 
        emit MilkBatchAdded(walletMilkHub, "Pezzo di formaggio inserito !", _scadenza, _quantity, _price);
    }

    // Get CheesePiece -> address of  
    function getMilkBatch(uint256 _id) external view returns (uint256, string memory, uint256, uint256, uint256) {
        // Retrieve msg.sender 
        address walletMilkHub = msg.sender;

        return milkhubInventoryStorage.getMilkBatch(walletMilkHub,_id);
    }



    // Delete Cheese piece 
    // We can delete a cheese piece with -> address of Consumer and id of CheesePiece
    function deleteMilkBatch(uint256 _id) external returns(bool value) {
        // Retrieve msg.sender 
        address walletMilkHub = msg.sender;

        if(milkhubInventoryStorage.deleteMilkBatch(walletConsumer,_id)){
            emit MilkBatchDeleted(walletMilkHub,_id,"Pezzo di Formaggio e' stato eleminato");
            return true;
        }else {
            return false;
        }
    }
}