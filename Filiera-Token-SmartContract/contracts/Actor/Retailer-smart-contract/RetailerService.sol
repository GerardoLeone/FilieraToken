// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./RetailerStorage.sol";
import "../Filieratoken.sol";

contract RetailerService {

    // Address of Retailer Storage 
    RetailerStorage private retailerStorage;
    
    // Address of Token FT - ERC-20
    Filieratoken private filieraToken;

    // Address of Organization managing users
    address private RetailerOrg;
    
    // Event emitted when a retailer is deleted
    event RetailerDeleted(address indexed walletRetailer, string message);
    // Event emitted when a retailer is registered
    event RetailerRegistered(address indexed walletRetailer, string fullName, string message);

    /**
     * modifier --- OnlyOwner specifies that only the owner can make that call
     */
    modifier onlyOwner(address walletRetailer) {
        require(msg.sender != address(retailerStorage), "Address Not valid!");
        require(msg.sender != address(filieraToken), "Address Not valid!" );
        require(msg.sender != RetailerOrg ," Address not Valid, it is organization address");
        require(msg.sender == walletRetailer, "Only the account owner can perform this action");
        _;
    }

    constructor(address _retailerStorage, address _filieraToken) {
        retailerStorage = RetailerStorage(_retailerStorage);
        filieraToken = Filieratoken(_filieraToken);
        RetailerOrg = msg.sender;
    }

    /**
     * registerRetailer() registers users on the platform as Retailers 
     * - Inserts data into the blockchain
     * - Transfers 100 tokens from Filieratoken contract 
     * - Emits an event once the user is registered 
     */ 
    function registerRetailer(string memory fullName, string memory password, string memory email) external {

        address walletRetailer = msg.sender;        
        // Call function of Storage 
        retailerStorage.addUser(fullName, password, email, walletRetailer);

        filieraToken.transfer(walletRetailer, 100);

        // Emit Event on FireFly 
        emit RetailerRegistered(walletRetailer, fullName, "User has been registered!");
    }

    /**
     * login() performs login with email and password 
     * - Inserts email and password 
     * - Returns True if the user exists and has access with the correct credentials 
     * - Returns False otherwise 
     */
    function login(string memory email, string memory password) external view returns(bool) {
        address walletRetailer = msg.sender;
        
        return retailerStorage.loginUser(walletRetailer, email, password);
    }

    /**
     * getRetailerData() obtains data of the Retailer
     * - using the address of the Retailer, we can also view their data
     * - Sensitive data visible only to the Retailer itself 
     */
    function getRetailerData(address walletRetailer) external onlyOwner(walletRetailer) view returns (uint256, string memory, string memory, string memory, uint256) {
        // Call function of Storage         
        return retailerStorage.getUser(walletRetailer);
    }

    /**
     * deleteRetailer() deletes a Retailer from the system 
     * - Only the owner can perform the deletion 
     * - msg.sender should be the owner's address 
     */
    function deleteRetailer(address walletRetailer) external onlyOwner(walletRetailer)  {
        require(retailerStorage.deleteUser(walletRetailer), "Error during deletion");
        // Burn all tokens 
        filieraToken.burnToken(walletRetailer, filieraToken.balanceOf(walletRetailer));
        // Emit Event on FireFly 
        emit RetailerDeleted(walletRetailer,"User has been deleted!");
    }

    // Additional functions for Retailer
    // ...

}
