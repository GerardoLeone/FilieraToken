// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CheeseProducerStorage.sol";
import "../Filieratoken.sol";

contract CheeseProducerService {

    // Address of Cheese Producer Storage 
    CheeseProducerStorage private cheeseProducerStorage;
    
    // Address of Token FT - ERC-20
    Filieratoken private filieraToken;

    // Address of Organization managing users
    address private CheeseProducerOrg;
    
    // Event emitted when a producer is deleted
    event ProducerDeleted(address indexed walletCheeseProducer, string message);
    // Event emitted when a producer is registered
    event ProducerRegistered(address indexed walletCheeseProducer, string fullName, string message);

    /**
     * modifier --- OnlyOwner specifies that only the owner can make that call
     */
    modifier onlyOwner(address walletCheeseProducer) {
        require(msg.sender == address(cheeseProducerStorage), "Address Not valid!");
        require(msg.sender == address(filieraToken), "Address Not valid!" );
        require(msg.sender == CheeseProducerOrg ," Address not Valid, it is organization address");
        require(msg.sender == walletCheeseProducer, "Only the account owner can perform this action");
        _;
    }

    constructor(address _cheeseProducerStorage, address _filieraToken) {
        cheeseProducerStorage = CheeseProducerStorage(_cheeseProducerStorage);
        filieraToken = Filieratoken(_filieraToken);
        CheeseProducerOrg = msg.sender;
    }

    /**
     * registerCheeseProducer() registers users on the platform as Cheese Producers 
     * - Inserts data into the blockchain
     * - Transfers 100 tokens from Filieratoken contract 
     * - Emits an event once the user is registered 
     */ 
    function registerCheeseProducer(string memory fullName, string memory password, string memory email) external {

        address walletCheeseProducer = msg.sender;        
        // Call function of Storage 
        cheeseProducerStorage.addUser(fullName, password, email, walletCheeseProducer);

        filieraToken.transfer(walletCheeseProducer, 100);

        // Emit Event on FireFly 
        emit ProducerRegistered(walletCheeseProducer, fullName, "User has been registered!");
    }

    /**
     * login() performs login with email and password 
     * - Inserts email and password 
     * - Returns True if the user exists and has access with the correct credentials 
     * - Returns False otherwise 
     */
    function login(string memory email, string memory password) external view returns(bool) {
        address walletCheeseProducer = msg.sender;
        
        return cheeseProducerStorage.loginUser(walletCheeseProducer, email, password);
    }

    /**
     * getCheeseProducerData() obtains data of the Cheese Producer
     * - using the address of the Cheese Producer, we can also view their data
     * - Sensitive data visible only to the Cheese Producer itself 
     */
    function getCheeseProducerData(address walletCheeseProducer) external onlyOwner(walletCheeseProducer) view returns (uint256, string memory, string memory, string memory, uint256) {
        // Call function of Storage         
        return cheeseProducerStorage.getUser(walletCheeseProducer);
    }

    /**
     * deleteCheeseProducer() deletes a Cheese Producer from the system 
     * - Only the owner can perform the deletion 
     * - msg.sender should be the owner's address 
     */
    function deleteCheeseProducer(address walletCheeseProducer) external onlyOwner(walletCheeseProducer)  {
        require(cheeseProducerStorage.deleteUser(walletCheeseProducer), "Error during deletion");
        // Burn all tokens 
        filieraToken.burnToken(walletCheeseProducer, filieraToken.balanceOf(walletCheeseProducer));
        // Emit Event on FireFly 
        emit ProducerDeleted(walletCheeseProducer,"User has been deleted!");
    }

    // Additional functions for CheeseProducer
    // ...

}
