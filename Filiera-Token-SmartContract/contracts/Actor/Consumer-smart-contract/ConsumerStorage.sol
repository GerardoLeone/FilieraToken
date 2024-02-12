//SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;


import "../IUserStorageInterface.sol";


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
    mapping(address => Consumer) private  consumers;

    /**
     * addUser() effettuiamo la registrazione dell'utente Consumer 
     */
    function addUser(string memory _fullName, string memory _password,string memory _email, address walletConsumer) external {
        
        // Verifico che il walletConsumer non sia l'address che ha deployato il contratto
        require(walletConsumer != ConsumerOrg,"Address non Valido!");
        
        // Genera l'ID manualmente utilizzando keccak256
        bytes32 idHash = keccak256(abi.encodePacked(_fullName, _password, _email, walletConsumer));
        uint256 lastIdConsumer = uint256(idHash);

        require(consumers[walletConsumer].id == 0, "Consumer already registered");
        require(bytes(_fullName).length > 0, "Full name cannot be empty");
        require(bytes(_password).length > 0, "Password cannot be empty");
        require(bytes(_email).length > 0, "Email cannot be empty");
        
        // Crea un nuovo consumatore con l'ID univoco
        Consumer memory newConsumer = Consumer({
            id: lastIdConsumer,
            fullName: _fullName,
            password: _password,
            email: _email,
            balance: 100
        });

        // Inserisce il nuovo consumer all'interno della Lista dei Consumer 
        consumers[walletConsumer] = newConsumer;
    }

    /**
     * LoginUser() effettua il login dell'utente 
     * La comparazione Hash tra (email e password) di input e quelli salvati
     * return true se la comparazione è vera, La comparazione è falsa se l'hashing non risulta valido
     */
    function loginUser(address walletConsumer, string memory _email, string memory _password) external view returns(bool){

        require(address(walletConsumer)!= address(0), "Address utilizzato non valido, pari a 0!");
        // Verifico che il walletConsumer non sia l'address che ha deployato il contratto
        require(walletConsumer != ConsumerOrg,"Address non Valido!");
        // Verifica che l'utente esista all'interno della Lista dei Consumer 
        require( consumers[walletConsumer].id!=0  , "Utente non presente!");
        // Recupero il Consumer 
        Consumer storage consumer = consumers[walletConsumer];
        
        // Verifico che l'email e la password hashate sono uguali tra di loro 
        return keccak256(abi.encodePacked(consumer.email, consumer.password)) == keccak256(abi.encodePacked(_email, _password));
    }

    /**
     * getUser(walletConsumer) : 
     * Consumer visualizza le sue informazioni principali
     * - email, password , fullName , balance 
     */
    function getUser(address walletConsumer) external  view returns (uint256, string memory, string memory, string memory, uint256) {

        // Verifica che l'utente sia presente
        require( consumers[walletConsumer].id!=0  , "Utente non presente!");

        Consumer memory consumer = consumers[walletConsumer];

        // Restituisce i dati del consumatore
        return (consumer.id, consumer.fullName, consumer.password, consumer.email, consumer.balance);
    }

    

    // Funzione per eliminare il Consumer dato il suo indirizzo del wallet 
    function deleteUser(address walletConsumer) external returns(bool value){
        // Check exists Consumers
        require(consumers[walletConsumer].id!=0, "Utente non presente!");

        uint256 lastIdConsumer = uint256(keccak256(abi.encodePacked(
            consumers[walletConsumer].fullName,
            consumers[walletConsumer].password,
            consumers[walletConsumer].email,
            walletConsumer
               )));
        require (consumers[walletConsumer].id==lastIdConsumer, "Utente non Autorizzato!");

        delete consumers[walletConsumer];

        if(consumers[walletConsumer].id == 0 ){
            return true;
        }else {
            return false;
        }
    }

// ------------------------------------------------------------ CheeseProducer ------------------------------------------------------//



    /**
     * getConsumerToCheeseProducer() otteniamo le informazioni sensibili per un singolo cheeseProducer 
     * - email e fullName 
     */
    function getConsumerToCheeseProducer(address walletConsumer) external view returns (string memory, string memory){
        // Check exists walletConsumer
        require(consumers[walletConsumer].id!=0, "Utente non presente!");

        Consumer storage consumer = consumers[walletConsumer];

        return (consumer.fullName,consumer.email);
    }

// ------------------------------------------------------------------------ ConsumerInventoryService ----------------------------------------------------------//

    function isUserPresent(address walletConsumer) external view returns(bool){
        require(address(walletConsumer)!= address(0), "Address Consumer non valido!");
        
        return consumers[walletConsumer].id!=0;
    }




}   

