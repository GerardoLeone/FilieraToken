//SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;


import "./IUserStorageInterface.sol";


contract RetailerStorage is IUserStorageInterface {

    // Address of Organization che gestisce gli utenti
    address private  RetailerOrg;

    constructor(){
        RetailerOrg = msg.sender;
    }


    // Struttura per rappresentare gli attributi di un consumatore
    struct Retailer {
        uint256 id;
        string fullName;
        string password; // Si presume che sia già crittografata dal Front-End
        string email;
        uint256 balance;
    }

    // Mapping che collega l'indirizzo del portafoglio (wallet address) ai dati del consumatore
    mapping(address => Retailer) private   retailers;


    function addUser(string memory fullName, string memory password,string memory email, address walletRetaler) external {
        
        require( !(retailers[walletRetaler].id!=0 ) , "Utente gia' presente!");
        
        // Crea L'id univoco per l'utente 
        uint256 lastIdConsumer = uint256(keccak256(abi.encodePacked(fullName, password, email, walletRetaler)));

        
        // Crea un nuovo consumatore con l'ID univoco
        Retailer memory newRetailer = Retailer({
            id: lastIdConsumer,
            fullName: fullName,
            password: password,
            email: email,
            balance: 100
        });

        // Inserisce il nuovo consumer all'interno della Lista dei Consumer 
        retailers[walletRetaler] = newRetailer;
    }


    // Funzione per ottenere i dati di un consumatore dato il suo indirizzo del portafoglio
    function getUser(address walletRetailer) external  view returns (uint256, string memory, string memory, string memory, uint256) {
        // Verifica che l'utente sia presente
        require( retailers[walletRetailer].id!=0  , "Utente non presente!");

        Retailer memory retailer = retailers[walletRetailer];

        // Restituisce i dati del consumatore
        return (retailer.id, retailer.fullName, retailer.password, retailer.email, retailer.balance);
    }

    // Funzione per eliminare il Consumer dato il suo indirizzo del wallet 
    function deleteUser(address walletRetailer) external returns(bool value){
        require(retailers[walletRetailer].id!=0, "Utente non presente!");

        uint256 lastIdConsumer = uint256(keccak256(abi.encodePacked(
            retailers[walletRetailer].fullName,
            retailers[walletRetailer].password,
            retailers[walletRetailer].email,
            walletRetailer
               )));
        require (retailers[walletRetailer].id==lastIdConsumer, "Utente non Autorizzato!");

        delete retailers[walletRetailer];

        if(retailers[walletRetailer].id == 0 ){
            return true;
        }else {
            return false;
        }
    }


}   

