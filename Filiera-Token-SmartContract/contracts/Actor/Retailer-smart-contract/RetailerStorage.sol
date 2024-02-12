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
    mapping(address => Retailer) private  retailers;

    /**
     * addUser() effettuiamo la registrazione dell'utente retailer 
     */
    function addUser(string memory _fullName, string memory _password,string memory _email, address walletRetailer) external {
        
        // Verifico che il walletRetailer non sia l'address che ha deployato il contratto
        require(walletRetailer != RetailerOrg,"Address non Valido!");
        
        // Genera l'ID manualmente utilizzando keccak256
        bytes32 idHash = keccak256(abi.encodePacked(_fullName, _password, _email, walletRetailer));
        uint256 id = uint256(idHash);

        require(retailers[walletRetailer].id == 0, "Retailer already registered");
        require(bytes(_fullName).length > 0, "Full name cannot be empty");
        require(bytes(_password).length > 0, "Password cannot be empty");
        require(bytes(_email).length > 0, "Email cannot be empty");
        
        // Crea un nuovo consumatore con l'ID univoco
        Retailer memory newRetailer = Retailer({
            id: lastIdRetailer,
            fullName: _fullName,
            password: _password,
            email: _email,
            balance: 100
        });

        // Inserisce il nuovo consumer all'interno della Lista dei Consumer 
        retailers[walletRetailer] = newRetailer;
    }

    /**
     * LoginUser() effettua il login dell'utente 
     * La comparazione Hash tra (email e password) di input e quelli salvati
     * return true se la comparazione è vera, La comparazione è falsa se l'hashing non risulta valido
     */
    function loginUser(address walletRetailer, string memory _email, string memory _password) external view returns(bool){

        require(address(walletRetailer)!=0, "Address utilizzato non valido, pari a 0!");
        // Verifico che il walletretailer non sia l'address che ha deployato il contratto
        require(walletRetailer != RetailerOrg,"Address non Valido!");
        // Verifica che l'utente esista all'interno della Lista dei Retailer 
        require( retailers[walletRetailer].id!=0  , "Utente non presente!");
        // Recupero il Retailer 
        Retailer storage retailer = retailers[walletRetailer];
        
        // Verifico che l'email e la password hashate sono uguali tra di loro 
        return keccak256(abi.encodePacked(retailer.email, retailer.password)) == keccak256(abi.encodePacked(_email, _password));
    }

    /**
     * getUser(walletretailer) : 
     * retailer visualizza le sue informazioni principali
     * - email, password , fullName , balance 
     */
    function getUser(address walletRetailer) external  view returns (uint256, string memory, string memory, string memory, uint256) {

        // Verifica che l'utente sia presente
        require( retailers[walletRetailer].id!=0  , "Utente non presente!");

        Retailer memory retailer = retailers[walletRetailer];

        // Restituisce i dati del consumatore
        return (retailer.id, retailer.fullName, retailer.password, retailer.email, retailer.balance);
    }

    

    // Funzione per eliminare il Consumer dato il suo indirizzo del wallet 
    function deleteUser(address walletRetailer) external returns(bool value){
        // Check exists retailers
        require(retailers[walletRetailer].id!=0, "Utente non presente!");

        uint256 lastIdRetailer = uint256(keccak256(abi.encodePacked(
            retailers[walletRetailer].fullName,
            retailers[walletRetailer].password,
            retailers[walletRetailer].email,
            walletRetailer
               )));
        require (retailers[walletRetailer].id==lastIdRetailer, "Utente non Autorizzato!");

        delete retailers[walletRetailer];

        if(retailers[walletRetailer].id == 0 ){
            return true;
        }else {
            return false;
        }
    }

// ------------------------------------------------------------ CheeseProducer ------------------------------------------------------//



    /**
     * getRetailerToCheeseProducer() otteniamo le informazioni sensibili per un singolo cheeseProducer 
     * - email e fullName 
     */
    function getRetailerToCheeseProducer(address walletRetailer) view returns (string memory, string memory){
        // Check exists walletretailer
        require(retailers[walletRetailer].id!=0, "Utente non presente!");

        Retailer storage retailer = retailers[walletRetailer];

        return (retailer.fullName,retailer.email);
    }

// ------------------------------------------------------------------------ RetailerInventoryService ----------------------------------------------------------//

    function isUserPresent(address walletRetailer) external view returns(bool){
        require(address(walletRetailer)!=0, "Address Retailer non valido!");
        
        return retailers[walletRetailer].id!=0;
    }




}   

