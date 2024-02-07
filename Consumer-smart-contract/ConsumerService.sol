// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ConsumerStorage.sol";
import "./Filieratoken.sol";


contract ConsumerService {

    // Address of Consumer Storage 
    ConsumerStorage private consumerStorage;
    // Address of Token FT - ERC-20
    Filieratoken private filieraToken;

    // Address of Organization che gestisce gli utenti
    address private  ConsumerOrg;

    // Evento emesso al momento della cancellazione di un consumatore
    event ConsumerDeleted(address indexed walletConsumer, string message);

    // Evento emesso al momento della registrazione di un consumatore
    event ConsumerRegistered(address indexed walletConsumer, string fullName, string message);

    // We must deploy first : 
    // - ConsumerStorage 
    // - ConsumerService 
    constructor(address _consumerStorage, address _filieraToken) {
        consumerStorage = ConsumerStorage(_consumerStorage);
        filieraToken = Filieratoken(_filieraToken);
        ConsumerOrg = msg.sender;
    }

    // Function to Register Consumer to Application 
    // Settiamo  - msg.sender come il valore del wallet del Consumer 
    function registerConsumer(string memory fullName, string memory password, string memory email) external {
        // Verifico che l'address sia diverso da quello di Deploy 
        require(msg.sender != ConsumerOrg,"Address non Valido!");
        
        //Call function of Storage 
        consumerStorage.addUser(fullName, password, email, msg.sender);

        filieraToken.transfer(msg.sender, 100);

        // Emit Event on FireFly 
        emit ConsumerRegistered(msg.sender, fullName, "Utente e' stato registrato!");
    }

    function getConsumerData() external view returns (uint256, string memory, string memory, string memory, uint256) {
        // Call function of Storage 
        address walletConsumer = msg.sender;
        // Verifico che l'address sia diverso da quello di Deploy 
        require(walletConsumer != ConsumerOrg,"Address non Valido!");

        return consumerStorage.getUser(walletConsumer);
    }



    // Delete Consumer - we can delete consumer on Blockchain
    function deleteConsumer() external {
        address walletConsumer = msg.sender;
        require(consumerStorage.deleteUser(walletConsumer), "Errore durante la cancellazione");
        // Burn all token 
        filieraToken.burnToken(walletConsumer, filieraToken.balanceOf(walletConsumer));
        // Emit Event on FireFly 
        emit ConsumerDeleted(walletConsumer,"Utente e' stato eliminato!");
    }

}
