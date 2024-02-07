// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./RetailerStorage.sol";
import "./Filieratoken.sol";


contract RetailerService {

    // Address of Consumer Storage 
    RetailerStorage private retailerStorage;
    // Address of Token FT - ERC-20
    Filieratoken private filieraToken;

    // Address of Organization che gestisce gli utenti
    address private  RetailerOrg;

    // Evento emesso al momento della cancellazione di un consumatore
    event RetailerDeleted(address indexed walletRetailer, string message);

    // Evento emesso al momento della registrazione di un consumatore
    event RetailerRegistered(address indexed walletRetailer, string fullName, string message);

    // We must deploy first : 
    // - ConsumerStorage 
    // - ConsumerService 
    constructor(address _retailerStorage, address _filieraToken) {
        retailerStorage = RetailerStorage(_retailerStorage);
        filieraToken = Filieratoken(_filieraToken);
        RetailerOrg = msg.sender;
    }

    // Function to Register Consumer to Application 
    // Settiamo  - msg.sender come il valore del wallet del Consumer 
    function registerRetailer(string memory fullName, string memory password, string memory email) external {
        // Verifico che l'address sia diverso da quello di Deploy 
        require(msg.sender != RetailerOrg,"Address non Valido!");
        //Call function of Storage 
        retailerStorage.addUser(fullName, password, email, msg.sender);

        filieraToken.transfer(msg.sender, 100);

        // Emit Event on FireFly 
        emit RetailerRegistered(msg.sender, fullName, "Utente e' stato registrato!");
    }

    function getRetailerData() external view returns (uint256, string memory, string memory, string memory, uint256) {
        // Call function of Storage 
        address walletRetailer = msg.sender;
        // Verifico che l'address sia diverso da quello di Deploy 
        require(walletRetailer != RetailerOrg,"Address non Valido!");

        return retailerStorage.getUser(walletRetailer);
    }



    // Delete Consumer - we can delete consumer on Blockchain
    function deleteConsumer() external {

        address walletRetailer = msg.sender;
        
        require(retailerStorage.deleteUser(walletRetailer), "Errore durante la cancellazione");
        // Burn all token 
        filieraToken.burnToken(walletRetailer, filieraToken.balanceOf(walletRetailer));
        // Emit Event on FireFly 
        emit RetailerDeleted(walletRetailer,"Utente e' stato eliminato!");
    }

}
