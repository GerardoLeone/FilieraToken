//SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;


import "./IUserStorageInterface.sol";


contract MilkHubStorage is IUserStorageInterface {

    // Address of Organization che gestisce gli utenti
    address private  MilkHubOrg;

    constructor(){
        MilkHubOrg = msg.sender;
    }


    // Struttura per rappresentare gli attributi di un consumatore
    struct MilkHub {
        uint256 id;
        string fullName;
        string password; // Si presume che sia già crittografata dal Front-End
        string email;
        uint256 balance;
    }

    // Mapping che collega l'indirizzo del portafoglio (wallet address) ai dati del consumatore
    mapping(address => MilkHub) private  milkhubs;


    function addUser(string memory fullName, string memory password,string memory email, address walletMilkHub) external {
        
        require( !(milkhubs[walletMilkHub].id!=0 ) , "Utente gia' presente!");
        
        // Crea L'id univoco per l'utente 
        uint256 lastIdMilkHub = uint256(keccak256(abi.encodePacked(fullName, password, email, walletMilkHub)));

        
        // Crea un nuovo consumatore con l'ID univoco
        Retailer memory newMilkHub = Retailer({
            id: lastIdMilkHub,
            fullName: fullName,
            password: password,
            email: email,
            balance: 100
        });

        // Inserisce il nuovo consumer all'interno della Lista dei Consumer 
        milkhubs[walletMilkHub] = newMilkHub;
    }


    // Funzione per ottenere i dati di un consumatore dato il suo indirizzo del portafoglio
    function getUser(address walletMilkHub) external  view returns (uint256, string memory, string memory, string memory, uint256) {
        // Verifica che l'utente sia presente
        require( milkhubs[walletMilkHub].id!=0  , "Utente non presente!");

        MilkHub memory milkhub = milkhubs[walletMilkHub];

        // Restituisce i dati del consumatore
        return (milkhub.id, milkhub.fullName, milkhub.password, milkhub.email, milkhub.balance);
    }

    // Funzione per eliminare il Consumer dato il suo indirizzo del wallet 
    function deleteUser(address walletMilkHub) external returns(bool value){
        require(milkhubs[walletMilkHub].id!=0, "Utente non presente!");

        uint256 lastIdMilkHub = uint256(keccak256(abi.encodePacked(
            milkhubs[walletMilkHub].fullName,
            milkhubs[walletMilkHub].password,
            milkhubs[walletMilkHub].email,
            walletMilkHub
               )));
        require (milkhubs[walletMilkHub].id==lastIdMilkHub, "Utente non Autorizzato!");

        delete milkhubs[walletMilkHub];

        if(milkhubs[walletMilkHub].id == 0 ){
            return true;
        }else {
            return false;
        }
    }


}   

