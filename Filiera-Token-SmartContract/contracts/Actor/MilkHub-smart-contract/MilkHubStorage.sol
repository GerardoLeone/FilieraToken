//SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;


import "../IUserStorageInterface.sol";


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

    /**
     * addUser() effettuiamo la registrazione dell'utente MilkHub 
     */
    function addUser(string memory _fullName, string memory _password,string memory _email, address walletMilkHub) external {
        
        // Verifico che il walletMilkHub non sia l'address che ha deployato il contratto
        require(walletMilkHub == MilkHubOrg,"Address non Valido!");
        
        // Genera l'ID manualmente utilizzando keccak256
        bytes32 idHash = keccak256(abi.encodePacked(_fullName, _password, _email, walletMilkHub));
        uint256 lastIdMilkHub = uint256(idHash);

        require(milkhubs[walletMilkHub].id == 0, "MilkHub already registered");
        require(bytes(_fullName).length > 0, "Full name cannot be empty");
        require(bytes(_password).length > 0, "Password cannot be empty");
        require(bytes(_email).length > 0, "Email cannot be empty");
        
        // Crea un nuovo consumatore con l'ID univoco
        MilkHub memory newMilkHub = MilkHub({
            id: lastIdMilkHub,
            fullName: _fullName,
            password: _password,
            email: _email,
            balance: 100
        });

        // Inserisce il nuovo consumer all'interno della Lista dei Consumer 
        milkhubs[walletMilkHub] = newMilkHub;
    }

    /**
     * LoginUser() effettua il login dell'utente 
     * La comparazione Hash tra (email e password) di input e quelli salvati
     * return true se la comparazione è vera, La comparazione è falsa se l'hashing non risulta valido
     */
    function loginUser(address walletMilkHub, string memory _email, string memory _password) external view returns(bool){

        require(address(walletMilkHub)!= address(0), "Address utilizzato non valido, pari a 0!");
        // Verifico che il walletMilkHub non sia l'address che ha deployato il contratto
        require(walletMilkHub == MilkHubOrg,"Address non Valido!");
        // Verifica che l'utente esista all'interno della Lista dei MilkHub 
        require( milkhubs[walletMilkHub].id!=0  , "Utente non presente!");
        // Recupero il MilkHub 
        MilkHub storage milkhub = milkhubs[walletMilkHub];
        
        // Verifico che l'email e la password hashate sono uguali tra di loro 
        return keccak256(abi.encodePacked(milkhub.email, milkhub.password)) == keccak256(abi.encodePacked(_email, _password));
    }

    /**
     * getUser(walletMilkHub) : 
     * MilkHub visualizza le sue informazioni principali
     * - email, password , fullName , balance 
     */
    function getUser(address walletMilkHub) external  view returns (uint256, string memory, string memory, string memory, uint256) {

        // Verifica che l'utente sia presente
        require( milkhubs[walletMilkHub].id!=0  , "Utente non presente!");

        MilkHub memory milkhub = milkhubs[walletMilkHub];

        // Restituisce i dati del consumatore
        return (milkhub.id, milkhub.fullName, milkhub.password, milkhub.email, milkhub.balance);
    }

    

    // Funzione per eliminare il Consumer dato il suo indirizzo del wallet 
    function deleteUser(address walletMilkHub) external returns(bool value){
        // Check exists MilkHubs
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

// ------------------------------------------------------------ CheeseProducer ------------------------------------------------------//



    /**
     * getMilkHubToCheeseProducer() otteniamo le informazioni sensibili per un singolo cheeseProducer 
     * - email e fullName 
     */
    function getMilkHubToCheeseProducer(address walletMilkHub) external view returns (string memory, string memory){
        // Check exists walletMilkHub
        require(milkhubs[walletMilkHub].id!=0, "Utente non presente!");

        MilkHub storage milkhub = milkhubs[walletMilkHub];

        return (milkhub.fullName,milkhub.email);
    }

// ------------------------------------------------------------------------ MilkHubInventoryService ----------------------------------------------------------//

    function isUserPresent(address walletMilkHub) external view returns(bool){
        require(address(walletMilkHub)!= address(0), "Address MilkHub non valido!");
        
        return milkhubs[walletMilkHub].id!=0;
    }




}   

