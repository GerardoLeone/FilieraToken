// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CheeseProducerStorage.sol";
import "./Filieratoken.sol";


contract CheeseProducerService {

    // Address of Consumer Storage 
    CheeseProducerStorage private cheeseProducerStorage;
    // Address of Token FT - ERC-20
    Filieratoken private filieraToken;

    // Address of Organization che gestisce gli utenti
    address private  CheeseProducerOrg;

    // Evento emesso al momento della cancellazione di un consumatore
    event CheeseProducerDeleted(address indexed walletCheeseProducer, string message);
    // Evento emesso al momento della registrazione di un consumatore
    event CheeseProducerRegistered(address indexed walletCheeseProducer, string fullName, string message);

    // We must deploy first : 
    // - ConsumerStorage 
    // - ConsumerService 
    constructor(address _cheeseProducerStorage, address _filieraToken) {
        cheeseProducerStorage = ConsumerStorage(_cheeseProducerStorage);
        filieraToken = Filieratoken(_filieraToken);
        CheeseProducerOrg = msg.sender;
    }


    modifier onlyIfUserPresent() {
        require(this.isUserPresent(msg.sender), "User is not present in data");
        _;
    }


    // Function to Register Consumer to Application 
    // Settiamo  - msg.sender come il valore del wallet del Consumer 
    function registerConsumer(string memory fullName, string memory password, string memory email) external {

        address walletCheeseProducer = msg.sender;


        // Verifico che l'address sia diverso da quello di Deploy 
        require(walletCheeseProducer != CheeseProducerOrg,"Address non Valido!");
        
        //Call function of Storage 
        cheeseProducerStorage.addUser(fullName, password, email, walletCheeseProducer);

        filieraToken.transfer(walletCheeseProducer, 100);

        // Emit Event on FireFly 
        emit CheeseProducerRegistered(walletCheeseProducer, fullName, "Utente e' stato registrato!");
    }

    function getCheeseProducerData() external onlyIfUserPresent view returns (uint256, string memory, string memory, string memory, uint256) {
        // Call function of Storage 
        address walletCheeseProducer = msg.sender;
        // Verifico che l'address sia diverso da quello di Deploy 
        require(walletCheeseProducer != CheeseProducerOrg,"Address non Valido!");

        return cheeseProducerStorage.getUser(walletCheeseProducer);
    }

    function isUserPresent(address walletCheeseProducer) external view returns (bool){
        require(cheeseProducerStorage.getUser(walletCheeseProducer)!=0, "Utente non e' presente, wallet : "+walletCheeseProducer);
        return true;
    }


    // Delete Consumer - we can delete consumer on Blockchain
    function deleteCheeseProducer() external onlyIfUserPresent {
        address walletCheeseProducer = msg.sender;
        require(cheeseProducerStorage.deleteUser(walletCheeseProducer), "Errore durante la cancellazione");
        // Burn all token 
        filieraToken.burnToken(walletCheeseProducer, filieraToken.balanceOf(walletCheeseProducer));
        // Emit Event on FireFly 
        emit ConsumerDeleted(walletCheeseProducer,"Utente e' stato eliminato!");
    }

}
