// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "../IUserStorageInterface.sol";

contract CheeseProducerStorage is IUserStorageInterface {

    // Address of Organization managing users
    address private CheeseProducerOrg;

    constructor(){
        CheeseProducerOrg = msg.sender;
    }

    // Structure to represent the attributes of a cheese producer
    struct CheeseProducer {
        uint256 id;
        string fullName;
        string password; // Presumed to be already encrypted by the Front-End
        string email;
        uint256 balance;
    }

    // Mapping linking the wallet address to the data of the cheese producer
    mapping(address => CheeseProducer) private cheeseProducers;

    /**
     * addUser() registers the Cheese Producer user
     */
    function addUser(string memory _fullName, string memory _password, string memory _email, address walletCheeseProducer) external {

        // Verify that the walletCheeseProducer is not the address that deployed the contract
        require(walletCheeseProducer != CheeseProducerOrg, "Invalid Address!");

        // Manually generate the ID using keccak256
        bytes32 idHash = keccak256(abi.encodePacked(_fullName, _password, _email, walletCheeseProducer));
        uint256 lastIdCheeseProducer = uint256(idHash);

        require(cheeseProducers[walletCheeseProducer].id == 0, "Cheese Producer already registered");
        require(bytes(_fullName).length > 0, "Full name cannot be empty");
        require(bytes(_password).length > 0, "Password cannot be empty");
        require(bytes(_email).length > 0, "Email cannot be empty");

        // Create a new cheese producer with the unique ID
        CheeseProducer memory newCheeseProducer = CheeseProducer({
            id: lastIdCheeseProducer,
            fullName: _fullName,
            password: _password,
            email: _email,
            balance: 100
        });

        // Insert the new cheese producer into the list of cheese producers
        cheeseProducers[walletCheeseProducer] = newCheeseProducer;
    }

    /**
     * loginUser() logs in the user
     * Compares the hash between (email and password) of input and those saved
     * Returns true if the comparison is true, false if the hashing is not valid
     */
    function loginUser(address walletCheeseProducer, string memory _email, string memory _password) external view returns(bool){

        require(address(walletCheeseProducer) != address(0), "Invalid address, equals to 0!");
        // Verify that the walletCheeseProducer is not the address that deployed the contract
        require(walletCheeseProducer != CheeseProducerOrg, "Invalid Address!");
        // Verify that the user exists in the list of Cheese Producers 
        require(cheeseProducers[walletCheeseProducer].id != 0, "User not present!");
        // Retrieve the Cheese Producer 
        CheeseProducer storage cheeseProducer = cheeseProducers[walletCheeseProducer];

        // Verify that the hashed email and password are equal to each other 
        return keccak256(abi.encodePacked(cheeseProducer.email, cheeseProducer.password)) == keccak256(abi.encodePacked(_email, _password));
    }

    /**
     * getUser(walletCheeseProducer): 
     * Cheese Producer views their main information
     * - email, password, fullName, balance
     */
    function getUser(address walletCheeseProducer) external view returns (uint256, string memory, string memory, string memory, uint256) {

        // Verify that the user is present
        require(cheeseProducers[walletCheeseProducer].id != 0, "User not present!");

        CheeseProducer memory cheeseProducer = cheeseProducers[walletCheeseProducer];

        // Return the data of the cheese producer
        return (cheeseProducer.id, cheeseProducer.fullName, cheeseProducer.password, cheeseProducer.email, cheeseProducer.balance);
    }

    // Function to delete the Cheese Producer given their wallet address
    function deleteUser(address walletCheeseProducer) external returns(bool value){
        // Check if Cheese Producer exists
        require(cheeseProducers[walletCheeseProducer].id != 0, "User not present!");

        uint256 lastIdCheeseProducer = uint256(keccak256(abi.encodePacked(
            cheeseProducers[walletCheeseProducer].fullName,
            cheeseProducers[walletCheeseProducer].password,
            cheeseProducers[walletCheeseProducer].email,
            walletCheeseProducer
               )));
        require (cheeseProducers[walletCheeseProducer].id == lastIdCheeseProducer, "User not authorized!");

        delete cheeseProducers[walletCheeseProducer];

        if(cheeseProducers[walletCheeseProducer].id == 0 ){
            return true;
        } else {
            return false;
        }
    }

// ------------------------------------------------------------------------------- CheeseProducerInventoryService -------------------------------------------------//

    // Function to check if a user is present
    function isUserPresent(address walletCheeseProducer) external view returns(bool){
        require(address(walletCheeseProducer) != address(0), "Invalid Cheese Producer address!");
        
        return cheeseProducers[walletCheeseProducer].id != 0;
    }

}
