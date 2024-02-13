// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ConsumerStorage.sol";
import "../Filieratoken.sol";


contract ConsumerService {

    // Address of Consumer Storage 
    ConsumerStorage private consumerStorage;
    
    // Address of Token FT - ERC-20
    Filieratoken private filieraToken;

    // Address of Organization che gestisce gli utenti
    address private  ConsumerOrg;


//---------------------------------------------------- Event of Service -----------------------------------------------------------------------//



    // Evento emesso al momento della cancellazione di un consumatore
    event ConsumerDeleted(address indexed walletConsumer, string message);
    // Evento emesso al momento della registrazione di un consumatore
    event ConsumerRegistered(address indexed walletConsumer, string fullName, string message);

    /**
     * modifier --- OnlyOwner specifica che solo il possessore può effettuare quella chiamata
     */
    modifier onlyOwner(address walletConsumer) {
        require(msg.sender != address(consumerStorage), "Address Not valid!");
        require(msg.sender != address(filieraToken), "Address Not valid!" );
        require(msg.sender != ConsumerOrg ," Address not Valid, it is organization address");
        require(msg.sender == walletConsumer, "Only the account owner can perform this action");
        _;
    }

    constructor(address _consumerStorage, address _filieraToken) {
        consumerStorage = ConsumerStorage(_consumerStorage);
        filieraToken = Filieratoken(_filieraToken);
        ConsumerOrg = msg.sender;
    }

    /**
     * registerConsumer() registra gli utenti della piattaforma che sono Consumer 
     * - Inserisce i dati all'interno della Blockchain
     * - Trasferisce 100 token dal contratto di FilieraToken 
     * - Emette un evento appena l'utente è stato registrato 
     *  */ 
    function registerConsumer(string memory fullName, string memory password, string memory email) external {

        address walletConsumer = msg.sender;        
        //Call function of Storage 
        consumerStorage.addUser(fullName, password, email,walletConsumer);

        filieraToken.transfer(walletConsumer, 100);

        // Emit Event on FireFly 
        emit ConsumerRegistered(walletConsumer, fullName, "Utente e' stato registrato!");
    }

    /**
     * login() effettua la Login con email e password 
     * - Inserisce l'email e la password 
     * - return True se l'utente esiste ed ha accesso con le giuste credenziali 
     * - return False altrimenti 
     */
    function login(string memory email, string memory password) external view returns(bool) {
        address walletConsumer = msg.sender;
        
        return consumerStorage.loginUser(walletConsumer, email, password);
    }

    /**
     * getConsumerData() otteniamo i dati del Consumer
     * - tramite l'address del Consumer riusciamo a visualizzare anche i suoi dati
     * - Dati sensibili e visibili solo dal Consumer stesso 
     */
    function getConsumerData(address walletConsumer) external onlyOwner(walletConsumer) view returns (uint256, string memory, string memory, string memory, uint256) {
        // Call function of Storage         
        return consumerStorage.getUser(walletConsumer);
    }



    /**
     * deleteConsumer() elimina un Consumer all'interno del sistema 
     * - Solo l'owner può effettuare l'eliminazione 
     * - msg.sender dovrebbe essere solo quello dell'owner 
     */
    function deleteConsumer(address walletConsumer, uint256 _id) external onlyOwner(walletConsumer)  {
        require(consumerStorage.deleteUser(walletConsumer, _id), "Errore durante la cancellazione");
        // Burn all token 
        filieraToken.burnToken(walletConsumer, filieraToken.balanceOf(walletConsumer));
        // Emit Event on FireFly 
        emit ConsumerDeleted(walletConsumer,"Utente e' stato eliminato!");
    }

// -------------------------------------------------------------------------------- CheeseProducer -----------------------------------------------------------------------//

    /**
     * viewConsumer() inseriamo l'address del Consumer per poter visualizzare i dati meno sensibili del Consumer
     * - Visualizziamo il Consumer ( email , fullname )
     */
    function viewConsumer(address walletConsumer) external view returns(string memory,string memory) {
        // Address dovrebbe essere il ruolo del CheeseProducer 
        address caller = msg.sender;

        require(address(walletConsumer)!=address(0), "Address Consumer non valido!");
        require(address(caller)!=address(0), "Address non valido!");

        return consumerStorage.getConsumerToCheeseProducer(walletConsumer);
    }

// --------------------------------------------------------------------------- ConsumerInventoryService ----------------------------------------------------//

    function isUserPresent(address walletConsumer) external view returns(bool){
        return consumerStorage.isUserPresent(walletConsumer);
    }



}
