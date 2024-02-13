// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MilkHubStorage.sol";
import "../Filieratoken.sol";


contract MilkHubService {

//-------------------------------------------------------------------- Contract Address Service --------------------------------------------------------------------//


    // Address of Consumer Storage 
    MilkHubStorage private milkhubStorage;
    
    // Address of Token FT - ERC-20
    Filieratoken private filieraToken;

    // Address of Organization che gestisce gli utenti
    address private  MilkHubOrg;



// --------------------------------------------------------------------- Event of Service ----------------------------------------------------------------//

    // Evento emesso al momento della cancellazione di un consumatore
    event MilkHubDeleted(address indexed walletMilkHub, string message);
    // Evento emesso al momento della registrazione di un consumatore
    event MilkHubRegistered(address indexed walletMilkHub, string fullName, string message);



//---------------------------------------------------------------------- Constructor ----------------------------------------------------------------------------//    
    constructor(address _milkhubStorage, address _filieraToken) {
        milkhubStorage = MilkHubStorage(_milkhubStorage);
        filieraToken = Filieratoken(_filieraToken);
        MilkHubOrg = msg.sender;
    }

// ------------------------------------------------------------ Modifier Of Service ---------------------------------------------------------------------------------//

    modifier onlyOwnWallet(address caller,address walletMilkHub){
        require(caller == walletMilkHub,"User Not Authorized!");
        _;
    }

    modifier onlyOrg(address sender){
        require(sender == MilkHubOrg,"User Not Authorized!");
        _;
    }

    // Verifica chi effettua la transazione : 
    // Verfica che l'address non sia l'organizzazione 
    // Verfica che l'address non sia lo smart contract del MilkHubStorage e FilieraToken 
    modifier checkAddress(address walletMilkHub){

        require(walletMilkHub != address(0),"Address is zero");
        require(walletMilkHub != address(milkhubStorage), "Address is MilkHubStorage Smart Contract!");
        require(walletMilkHub != address(filieraToken), "Address is FilieraToken Smart Contract!" );
        require(walletMilkHub != MilkHubOrg ,"Organization address");

        _;
    }


//--------------------------------------------------------------- Business Logic -------------------------------------------------------------------------------------------//

    /**
     * registerMilkHub() registra gli utenti della piattaforma che sono MilkHub 
     * - Inserisce i dati all'interno della Blockchain
     * - Trasferisce 100 token dal contratto di FilieraToken 
     * - Emette un evento appena l'utente è stato registrato 
     *  */ 
    function registerMilkHub(string memory fullName, string memory password, string memory email) external checkAddress(msg.sender) {

        address walletMilkHub = msg.sender;
        // Verifica che l'utente è gia' presente 
        require(!(this.isUserPresent(walletMilkHub)), "Utente gia' registrato !");

        // Chiama la funzione di Storage 
        milkhubStorage.addUser(fullName, password, email, walletMilkHub);

        // Autogenera dei token nel balance del MilkHub 
        filieraToken.transfer(walletMilkHub, 100);

        // Emette l'evento della registrazione dell'utente
        emit MilkHubRegistered(walletMilkHub, fullName, "Utente MilkHub e' stato registrato!");
    }

    /**
     * login() effettua la Login con email e password 
     * - Inserisce l'email e la password 
     * - return True se l'utente esiste ed ha accesso con le giuste credenziali 
     * - return False altrimenti 
     */
    function login(address walletMilkHub, string memory email, string memory password) external view checkAddress(msg.sender) onlyOwnWallet(msg.sender,walletMilkHub) returns(bool) {

        // Verifichiamo che l'utente è presente 
        require(this.isUserPresent(walletMilkHub),"Utente non e' presente!");
        
        return milkhubStorage.loginUser(walletMilkHub, email, password);
    }


    /**
     * deleteMilkHub() elimina un MilkHub all'interno del sistema 
     * - Solo l'owner può effettuare l'eliminazione 
     * - msg.sender dovrebbe essere solo quello dell'owner 
     */
    function deleteMilkHub(address walletMilkHub, uint256 _id) external checkAddress(msg.sender) onlyOwnWallet(msg.sender,walletMilkHub) {
        
        // Verifico che l'utente è presente 
        require(this.isUserPresent(walletMilkHub), "Utente non e' presente!");
        // Restituisce l'id del MilkHub tramite il suo address wallet
        require(milkhubStorage.getId(walletMilkHub) == _id , "Utente non Autorizzato!");
        // Effettuo la cancellazione dell'utente 
        require(milkhubStorage.deleteUser(walletMilkHub), "Errore durante la cancellazione");
        // Burn all token ( elimina i token che sono in circolazione, di un utente che non effettua transazioni ) 
        filieraToken.burnToken(walletMilkHub, filieraToken.balanceOf(walletMilkHub));
        // Emit Event on FireFly 
        emit MilkHubDeleted(walletMilkHub,"Utente e' stato eliminato!");
    }

// --------------------------------------------------------------------------- MilkHubInventoryService ----------------------------------------------------//

    function isUserPresent(address walletMilkHub) external view returns(bool){
        
        return milkhubStorage.isUserPresent(walletMilkHub);
    }



//----------------------------------------------------------------------------- Get Function ----------------------------------------------------------------------//

    /**
        -  Funzione getMilkHubId() attraverso l'address del MilkHub siamo riusciti ad ottenere il suo ID
    */
    function getMilkHubId(address walletMilkHub) external view checkAddress(walletMilkHub) onlyOwnWallet(msg.sender,walletMilkHub) returns (uint256){
        
        return milkhubStorage.getId(walletMilkHub);
    }

    
    /**
        - Funzione getFullName() attraverso l'address del MilkHub riusciamo a recuperare il suo FullName
    */
    function getMilkHubFullName(address walletMilkHub,uint256 _id) external view checkAddress(walletMilkHub) returns(string memory){

        return milkhubStorage.getFullName(walletMilkHub,_id);
    }

    /**
        - Funzione getEmail() attraverso l'address del MilkHub riusciamo a recuperare la sua Email 
    */
    function getMilkHubEmail(address walletMilkHub, uint256 _id) external view checkAddress(walletMilkHub) returns(string memory){
        
        return milkhubStorage.getEmail(walletMilkHub,_id);
    }

    /**
        - Funzione getBalance() attraverso l'address del MilkHub riusciamo a recuperare il suo Balance
    */
    function getMilkHubBalance(address walletMilkHub, uint256 _id) external view checkAddress(walletMilkHub) onlyOwnWallet(msg.sender,walletMilkHub) returns(uint256){

        return milkhubStorage.getBalance(walletMilkHub,_id);
    }

    /**
     * getMilkHubData() otteniamo i dati del MilkHub
     * - tramite l'address del MilkHub riusciamo a visualizzare anche i suoi dati
     * - Dati sensibili e visibili solo dal MilkHub stesso 
     */
    function getMilkHubData(address walletMilkHub, uint256 _id) external checkAddress(walletMilkHub) onlyOwnWallet(msg.sender,walletMilkHub) view returns (uint256, string memory, string memory, string memory, uint256) {
        // Verifico che l'utente è presente 
        require(this.isUserPresent(walletMilkHub), "Utente non e' presente!");
        // Restituisce l'id del MilkHub tramite il suo address wallet
        require(milkhubStorage.getId(walletMilkHub) == _id , "Utente non Autorizzato!");
        // Call function of Storage         
        return milkhubStorage.getUser(walletMilkHub);
    }

    
    // Funzione per far visualizzare i dati ai vari utenti esterni 
    function getMilkHubInfo(address walletMilkHub) external view checkAddress(walletMilkHub) returns (uint256, string memory, string memory) {
        
        // Verifico che l'utente esista
        require(this.isUserPresent(walletMilkHub), "User not found");

        uint256 id = milkhubStorage.getId(walletMilkHub); // Non è necessario, ma viene recuperato per rispettare il controllo in MilkHubStorage
        
        string memory fullName = milkhubStorage.getFullName(walletMilkHub, id);
        
        string memory email = milkhubStorage.getEmail(walletMilkHub, id);

        return (id, fullName, email);
    }




//------------------------------------------------------------ Set Function -------------------------------------------------------------------//

    // - Funzione updateBalance() attraverso l'address e l'id, riusciamo a settare il nuovo balance
    function updateMilkHubBalance(address walletMilkHub, uint256 balance) external checkAddress(walletMilkHub) {
        // Verifico che il Balance sia >0 
        require(balance>0,"Balance Not Valid");
        // Verifico che l'utente esista 
        require(this.isUserPresent(walletMilkHub),"User Not Found!");
        // Update Balance 
        milkhubStorage.updateBalance(walletMilkHub, balance);
    }


// ------------------------------------------------------------ Change Address Contract of Service -----------------------------------------------------//

    // TODO : Inserire onlyOrg(msg.sender) per verificare che quest'azione possa farla solo L'organizzazione 

    function changeMilkHubStorage(address _milkhubStorageNew)external {
        milkhubStorage = MilkHubStorage(_milkhubStorageNew);
    }

    // TODO : Inserire onlyOrg(msg.sender) per verificare che quest'azione possa farla solo L'organizzazione 

    function changeFilieraToken(address _filieraToken)external {
        filieraToken = Filieratoken(_filieraToken);
    }


}
