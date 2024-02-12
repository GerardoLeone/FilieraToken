// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MilkHubStorage.sol";
import "../Filieratoken.sol";


contract MilkHubService {

    // Address of Consumer Storage 
    MilkHubStorage private milkhubStorage;
    
    // Address of Token FT - ERC-20
    Filieratoken private filieraToken;

    // Address of Organization che gestisce gli utenti
    address private  MilkHubOrg;
    
    // Evento emesso al momento della cancellazione di un consumatore
    event MilkHubDeleted(address indexed walletMilkHub, string message);
    // Evento emesso al momento della registrazione di un consumatore
    event MilkHubRegistered(address indexed walletMilkHub, string fullName, string message);

    /**
     * modifier --- OnlyOwner specifica che solo il possessore può effettuare quella chiamata
     */
    modifier onlyOwner(address walletMilkHub) {
        require(msg.sender != address(milkhubStorage), "Address Not valid!");
        require(msg.sender != address(filieraToken), "Address Not valid!" );
        require(msg.sender != MilkHubOrg ," Address not Valid, it is organization address");
        require(msg.sender == walletMilkHub, "Only the account owner can perform this action");
        _;
    }

    constructor(address _milkhubStorage, address _filieraToken) {
        milkhubStorage = MilkHubStorage(_milkhubStorage);
        filieraToken = Filieratoken(_filieraToken);
        MilkHubOrg = msg.sender;
    }


    function changeMilkHubStorage(address _milkhubStorageNew)external {
        milkhubStorage = MilkHubStorage(_milkhubStorageNew);
    }


    function changeFilieraToken(address _filieraToken)external {
        filieraToken = Filieratoken(_filieraToken);
    }

    /**
     * registerMilkHub() registra gli utenti della piattaforma che sono MilkHub 
     * - Inserisce i dati all'interno della Blockchain
     * - Trasferisce 100 token dal contratto di FilieraToken 
     * - Emette un evento appena l'utente è stato registrato 
     *  */ 
    function registerMilkHub(string memory fullName, string memory password, string memory email) external {

        address walletMilkHub = msg.sender;        
        //Call function of Storage 
        milkhubStorage.addUser(fullName, password, email,walletMilkHub);

        filieraToken.transfer(walletMilkHub, 100);

        // Emit Event on FireFly 
        emit MilkHubRegistered(walletMilkHub, fullName, "Utente e' stato registrato!");
    }

    /**
     * login() effettua la Login con email e password 
     * - Inserisce l'email e la password 
     * - return True se l'utente esiste ed ha accesso con le giuste credenziali 
     * - return False altrimenti 
     */
    function login(string memory email, string memory password) external view returns(bool) {
        address walletMilkHub = msg.sender;
        
        return milkhubStorage.loginUser(walletMilkHub, email, password);
    }

    /**
     * getMilkHubData() otteniamo i dati del MilkHub
     * - tramite l'address del MilkHub riusciamo a visualizzare anche i suoi dati
     * - Dati sensibili e visibili solo dal MilkHub stesso 
     */
    function getMilkHubData(address walletMilkHub) external onlyOwner(walletMilkHub) view returns (uint256, string memory, string memory, string memory, uint256) {
        // Call function of Storage         
        return milkhubStorage.getUser(walletMilkHub);
    }



    /**
     * deleteMilkHub() elimina un MilkHub all'interno del sistema 
     * - Solo l'owner può effettuare l'eliminazione 
     * - msg.sender dovrebbe essere solo quello dell'owner 
     */
    function deleteMilkHub(address walletMilkHub) external onlyOwner(walletMilkHub)  {
        require(milkhubStorage.deleteUser(walletMilkHub), "Errore durante la cancellazione");
        // Burn all token 
        filieraToken.burnToken(walletMilkHub, filieraToken.balanceOf(walletMilkHub));
        // Emit Event on FireFly 
        emit MilkHubDeleted(walletMilkHub,"Utente e' stato eliminato!");
    }

// -------------------------------------------------------------------------------- CheeseProducer -----------------------------------------------------------------------//

    /**
     * viewMilkHub() inseriamo l'address del MilkHub per poter visualizzare i dati meno sensibili del MilkHub
     * - Visualizziamo il MilkHub ( email , fullname )
     */
    function viewMilkHub(address walletMilkHub) external view returns(string memory,string memory) {
        // Address dovrebbe essere il ruolo del CheeseProducer 
        address caller = msg.sender;

        require(address(walletMilkHub)!=address(0), "Address MilkHub non valido!");
        require(address(caller)!=address(0), "Address non valido!");

        return milkhubStorage.getMilkHubToCheeseProducer(walletMilkHub);
    }

// --------------------------------------------------------------------------- MilkHubInventoryService ----------------------------------------------------//

    function isUserPresent(address walletMilkHub) external view returns(bool){
        return milkhubStorage.isUserPresent(walletMilkHub);
    }



}
