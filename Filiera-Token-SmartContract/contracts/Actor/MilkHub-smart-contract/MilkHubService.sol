// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MilkHubStorage.sol";
import "./Filieratoken.sol";


contract MilkHubService {

    // Address of Consumer Storage 
    MilkHubStorage private milkhubStorage;
    // Address of Token FT - ERC-20
    Filieratoken private filieraToken;

    // Address of Organization che gestisce gli utenti
    address private  MilkHubOrg;
    
    
    // Evento emesso al momento della cancellazione di un consumatore
    event ConsumerDeleted(address indexed walletMilkHub, string message);

    // Evento emesso al momento della registrazione di un consumatore
    event ConsumerRegistered(address indexed walletMilkHub, string fullName, string message);

    // We must deploy first : 
    // - ConsumerStorage 
    // - ConsumerService 
    constructor(address _milkhubStorage, address _filieraToken) {
        milkhubStorage = ConsumerStorage(_milkhubStorage);
        filieraToken = Filieratoken(_filieraToken);
        ConsumerOrg = msg.sender;
    }

    // Function to Register Consumer to Application 
    // Settiamo  - msg.sender come il valore del wallet del Consumer 
    function registerMilkHub(string memory fullName, string memory password, string memory email) external {

        address walletMilkHub = msg.sender;

        // Verifico che l'address sia diverso da quello di Deploy 
        require(walletMilkHub != ConsumerOrg,"Address non Valido!");
        
        //Call function of Storage 
        milkhubStorage.addUser(fullName, password, email,walletMilkHub);

        filieraToken.transfer(walletMilkHub, 100);

        // Emit Event on FireFly 
        emit ConsumerRegistered(walletMilkHub, fullName, "Utente e' stato registrato!");
    }

    function getConsumerData() external view returns (uint256, string memory, string memory, string memory, uint256) {
        // Call function of Storage 
        address walletMilkHub = msg.sender;
        // Verifico che l'address sia diverso da quello di Deploy 
        require(walletMilkHub != MilkHubOrg,"Address non Valido!");

        return milkhubStorage.getUser(walletMilkHub);
    }



    // Delete Consumer - we can delete consumer on Blockchain
    function deleteConsumer() external {
        address walletMilkHub = msg.sender;
        require(milkhubStorage.deleteUser(walletMilkHub), "Errore durante la cancellazione");
        // Burn all token 
        filieraToken.burnToken(walletMilkHub, filieraToken.balanceOf(walletMilkHub));
        // Emit Event on FireFly 
        emit ConsumerDeleted(walletMilkHub,"Utente e' stato eliminato!");
    }

}
