// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "../IUserStorageInterface.sol";

contract RetailerStorage is IUserStorageInterface {

    // Address of Organization managing users
    address private RetailerOrg;

    constructor(){
        RetailerOrg = msg.sender;
    }

    // Structure to represent the attributes of a retailer
    struct Retailer {
        uint256 id;
        string fullName;
        string password; // Presumed to be already encrypted by the Front-End
        string email;
        uint256 balance;
    }

    // Mapping linking the wallet address to the data of the retailer
    mapping(address => Retailer) private retailers;

    /**
     * addUser() registers the Retailer user
     */
    function addUser(string memory _fullName, string memory _password, string memory _email, address walletRetailer) external {
        
        // Verify that the walletRetailer is not the address that deployed the contract
        require(walletRetailer != RetailerOrg,"Address not Valid!");
        
        // Manually generate the ID using keccak256
        bytes32 idHash = keccak256(abi.encodePacked(_fullName, _password, _email, walletRetailer));
        uint256 lastIdRetailer = uint256(idHash);

        require(retailers[walletRetailer].id == 0, "Retailer already registered");
        require(bytes(_fullName).length > 0, "Full name cannot be empty");
        require(bytes(_password).length > 0, "Password cannot be empty");
        require(bytes(_email).length > 0, "Email cannot be empty");
        
        // Create a new retailer with the unique ID
        Retailer memory newRetailer = Retailer({
            id: lastIdRetailer,
            fullName: _fullName,
            password: _password,
            email: _email,
            balance: 100
        });

        // Insert the new retailer into the list of retailers
        retailers[walletRetailer] = newRetailer;
    }

    /**
     * loginUser() logs in the user
     * Compares the hash between (email and password) of input and those saved
     * Returns true if the comparison is true, false if the hashing is not valid
     */
    function loginUser(address walletRetailer, string memory _email, string memory _password) external view returns(bool){

        require(address(walletRetailer)!= address(0), "Invalid address, equals to 0!");
        // Verify that the walletRetailer is not the address that deployed the contract
        require(walletRetailer != RetailerOrg,"Address not Valid!");
        // Verify that the user exists in the list of Retailers 
        require( retailers[walletRetailer].id!=0  , "User not present!");
        // Retrieve the Retailer 
        Retailer storage retailer = retailers[walletRetailer];
        
        // Verify that the hashed email and password are equal to each other 
        return keccak256(abi.encodePacked(retailer.email, retailer.password)) == keccak256(abi.encodePacked(_email, _password));
    }

    /**
     * getUser(walletRetailer): 
     * Retailer views their main information
     * - email, password, fullName, balance
     */
    function getUser(address walletRetailer) external  view returns (uint256, string memory, string memory, string memory, uint256) {

        // Verify that the user is present
        require( retailers[walletRetailer].id!=0  , "User not present!");

        Retailer memory retailer = retailers[walletRetailer];

        // Return the data of the retailer
        return (retailer.id, retailer.fullName, retailer.password, retailer.email, retailer.balance);
    }

    // Function to delete the Retailer given their wallet address
    function deleteUser(address walletRetailer) external returns(bool value){
        // Check if Retailer exists
        require(retailers[walletRetailer].id!=0, "User not present!");

        uint256 lastIdRetailer = uint256(keccak256(abi.encodePacked(
            retailers[walletRetailer].fullName,
            retailers[walletRetailer].password,
            retailers[walletRetailer].email,
            walletRetailer
               )));
        require (retailers[walletRetailer].id==lastIdRetailer, "User not authorized!");

        delete retailers[walletRetailer];

        if(retailers[walletRetailer].id == 0 ){
            return true;
        }else {
            return false;
        }
    }

    /**
     * getRetailerToRetailer() obtains sensitive information for a single retailer
     * - email and fullName
     */
    function getRetailerToRetailer(address walletRetailer) external view returns (string memory, string memory){
        // Check if walletRetailer exists
        require(retailers[walletRetailer].id!=0, "User not present!");

        Retailer storage retailer = retailers[walletRetailer];

        return (retailer.fullName, retailer.email);
    }

    // Function to check if a user is present
    function isUserPresent(address walletRetailer) external view returns(bool){
        require(address(walletRetailer)!= address(0), "Invalid Retailer address!");
        
        return retailers[walletRetailer].id!=0;
    }

}
