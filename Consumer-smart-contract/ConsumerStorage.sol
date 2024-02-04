//SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;


import "./IUserStorageInterface.sol";


contract ConsumerStorage is IUserStorageInterface {

    // Address of Organization che gestisce gli utenti
    address private  ConsumerOrg;

    constructor(){
        ConsumerOrg = msg.sender;
    }


    // Struttura per rappresentare gli attributi di un consumatore
    struct Consumer {
        uint256 id;
        string fullName;
        string password; // Si presume che sia già crittografata dal Front-End
        string email;
        uint256 balance;
    }

    // Mapping che collega l'indirizzo del portafoglio (wallet address) ai dati del consumatore
    mapping(address => Consumer) private   consumers;


    function addUser(string memory fullName, string memory password,string memory email, address walletConsumer) external {
        
        require( !(consumers[walletConsumer].id!=0 ) , "Utente gia' presente!");
        
        // Crea L'id univoco per l'utente 
        uint256 lastIdConsumer = uint256(keccak256(abi.encodePacked(fullName, password, email, walletConsumer)));

        
        // Crea un nuovo consumatore con l'ID univoco
        Consumer memory newConsumer = Consumer({
            id: lastIdConsumer,
            fullName: fullName,
            password: password,
            email: email,
            balance: 100
        });

        // Inserisce il nuovo consumer all'interno della Lista dei Consumer 
        consumers[walletConsumer] = newConsumer;
    }


    // Funzione per ottenere i dati di un consumatore dato il suo indirizzo del portafoglio
    function getUser(address walletConsumer) external  view returns (uint256, string memory, string memory, string memory, uint256) {
        // Verifica che l'utente sia presente
        require( consumers[walletConsumer].id!=0  , "Utente non presente!");

        Consumer memory consumer = consumers[walletConsumer];

        // Restituisce i dati del consumatore
        return (consumer.id, consumer.fullName, consumer.password, consumer.email, consumer.balance);
    }

    // Funzione per eliminare il Consumer dato il suo indirizzo del wallet 
    function deleteUser(address walletConsumer) external returns(bool value){
        require(consumers[walletConsumer].id!=0, "Utente non presente!");

        uint256 lastIdConsumer = uint256(keccak256(abi.encodePacked(
            consumers[walletConsumer].fullName,
            consumers[walletConsumer].password,
            consumers[walletConsumer].email,
            walletConsumer
               )));
        require (consumers[walletConsumer].id==lastIdConsumer, "Utente non Autorizzato!");

        delete consumers[walletConsumer];

        return true;
    }


}   

