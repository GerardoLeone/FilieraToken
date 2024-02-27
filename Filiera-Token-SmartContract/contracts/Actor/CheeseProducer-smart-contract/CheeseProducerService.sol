// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./CheeseProducerStorage.sol";
import "contracts/Service/Filieratoken.sol";

contract CheeseProducerService {

//-------------------------------------------------------------------- Contract Address Service --------------------------------------------------------------------//


    // Address of Consumer Storage 
    CheeseProducerStorage private cheeseProducerStorage;
    
    // Address of Token FT - ERC-20
    Filieratoken private filieraToken;

    // Address of Organization che gestisce gli utenti
    address private  CheeseProducerOrg;



// --------------------------------------------------------------------- Event of Service ----------------------------------------------------------------//

    // Evento emesso al momento della cancellazione di un consumatore
    event CheeseProducerDeleted(address indexed walletCheeseProducer, string message);
    // Evento emesso al momento della registrazione di un consumatore
    event CheeseProducerRegistered(address indexed walletCheeseProducer, string fullName, string message);



//---------------------------------------------------------------------- Constructor ----------------------------------------------------------------------------//    
    constructor(address _cheeseProducerStorage, address _filieraToken) {
        cheeseProducerStorage = CheeseProducerStorage(_cheeseProducerStorage);
        filieraToken = Filieratoken(_filieraToken);
        CheeseProducerOrg = msg.sender;
    }

// ------------------------------------------------------------ Modifier Of Service ---------------------------------------------------------------------------------//

  
    modifier _onlyOrg(address sender){
        require(sender == CheeseProducerOrg,"User Not Authorized!");
        _;
    }

    // Verifica chi effettua la transazione : 
    // Verfica che l'address non sia l'organizzazione 
    // Verfica che l'address non sia lo smart contract del CheeseProducerStorage e FilieraToken 
    modifier checkAddress(address walletCheeseProducer){

        require(walletCheeseProducer != address(0),"Address is zero");
        require(walletCheeseProducer != address(cheeseProducerStorage), "Address is CheeseProducerStorage Smart Contract!");
        require(walletCheeseProducer != address(filieraToken), "Address is FilieraToken Smart Contract!" );
        require(walletCheeseProducer != CheeseProducerOrg ,"Organization address");

        _;
    }


//--------------------------------------------------------------- Business Logic -------------------------------------------------------------------------------------------//

    /**
     * registerCheeseProducer() registra gli utenti della piattaforma che sono CheeseProducer 
     * - Inserisce i dati all'interno della Blockchain
     * - Trasferisce 100 token dal contratto di FilieraToken 
     * - Emette un evento appena l'utente è stato registrato 
     *  */ 
    function registerCheeseProducer(
        string memory fullName,
        string memory password,
        string memory email,
        address walletCheeseProducer
        ) external checkAddress(walletCheeseProducer) {

        // Verifica che l'utente è gia' presente 
        require(!(this.isUserPresent(walletCheeseProducer)), "Utente gia' registrato !");

        // Chiama la funzione di Storage 
        cheeseProducerStorage.addUser(fullName, password, email, walletCheeseProducer);

        // Autogenera dei token nel balance del CheeseProducer 
        require(filieraToken.registerUserWithToken(address(walletCheeseProducer), 100),"Transfer not valid!");

        // Emette l'evento della registrazione dell'utente
        emit CheeseProducerRegistered(walletCheeseProducer, fullName, "Utente CheeseProducer e' stato registrato!");
    }

    /**
     * login() effettua la Login con email e password 
     * - Inserisce l'email e la password 
     * - return True se l'utente esiste ed ha accesso con le giuste credenziali 
     * - return False altrimenti 
     */
    function login(
        address walletCheeseProducer,
        string memory email,
        string memory password
        ) external view checkAddress(walletCheeseProducer)  returns(bool) {

        // Verifichiamo che l'utente è presente 
        require(this.isUserPresent(walletCheeseProducer),"Utente non e' presente!");
        
        return cheeseProducerStorage.loginUser(walletCheeseProducer, email, password);
    }


    /**
     * deleteCheeseProducer() elimina un CheeseProducer all'interno del sistema 
     * - Solo l'owner può effettuare l'eliminazione 
     * - msg.sender dovrebbe essere solo quello dell'owner 
     */
    function deleteCheeseProducer(address walletCheeseProducer, uint256 _id) external checkAddress(walletCheeseProducer){
        
        // Verifico che l'utente è presente 
        require(this.isUserPresent(walletCheeseProducer), "Utente non e' presente!");
        // Restituisce l'id del CheeseProducer tramite il suo address wallet
        require(cheeseProducerStorage.getId(walletCheeseProducer) == _id , "Utente non Autorizzato!");
        // Effettuo la cancellazione dell'utente 
        require(cheeseProducerStorage.deleteUser(walletCheeseProducer), "Errore durante la cancellazione");
        // Burn all token ( elimina i token che sono in circolazione, di un utente che non effettua transazioni ) 
        filieraToken.burnToken(walletCheeseProducer, filieraToken.balanceOf(walletCheeseProducer));
        // Emit Event on FireFly 
        emit CheeseProducerDeleted(walletCheeseProducer,"Utente e' stato eliminato!");
    }

// --------------------------------------------------------------------------- CheeseProducerInventoryService ----------------------------------------------------//

    function isUserPresent(address walletCheeseProducer) external view  checkAddress(walletCheeseProducer)returns(bool){
        
        return cheeseProducerStorage.isUserPresent(walletCheeseProducer);
    }



//----------------------------------------------------------------------------- Get Function ----------------------------------------------------------------------//

    /**
        -  Funzione getCheeseProducerId() attraverso l'address del CheeseProducer siamo riusciti ad ottenere il suo ID
    */
    function getCheeseProducerId(address walletCheeseProducer) external view checkAddress(walletCheeseProducer)  returns (uint256){
        
        return cheeseProducerStorage.getId(walletCheeseProducer);
    }

    
    /**
        - Funzione getFullName() attraverso l'address del CheeseProducer riusciamo a recuperare il suo FullName
    */
    function getCheeseProducerFullName(address walletCheeseProducer,uint256 _id) external view checkAddress(walletCheeseProducer) returns(string memory){

        return cheeseProducerStorage.getFullName(walletCheeseProducer,_id);
    }

    /**
        - Funzione getEmail() attraverso l'address del CheeseProducer riusciamo a recuperare la sua Email 
    */
    function getCheeseProducerEmail(address walletCheeseProducer, uint256 _id) external view checkAddress(walletCheeseProducer) returns(string memory){
        
        return cheeseProducerStorage.getEmail(walletCheeseProducer,_id);
    }

    /**
        - Funzione getBalance() attraverso l'address del CheeseProducer riusciamo a recuperare il suo Balance
    */
    function getCheeseProducerBalance(address walletCheeseProducer, uint256 _id) external view checkAddress(walletCheeseProducer)  returns(uint256){

        return cheeseProducerStorage.getBalance(walletCheeseProducer,_id);
    }

    /**
     * getCheeseProducerData() otteniamo i dati del CheeseProducer
     * - tramite l'address del CheeseProducer riusciamo a visualizzare anche i suoi dati
     * - Dati sensibili e visibili solo dal CheeseProducer stesso 
     */
    function getCheeseProducerData(address walletCheeseProducer, uint256 _id) external checkAddress(walletCheeseProducer)  view returns (uint256, string memory, string memory, string memory, uint256) {
        // Verifico che l'utente è presente 
        require(this.isUserPresent(walletCheeseProducer), "Utente non e' presente!");
        // Restituisce l'id del CheeseProducer tramite il suo address wallet
        require(cheeseProducerStorage.getId(walletCheeseProducer) == _id , "Utente non Autorizzato!");
        // Call function of Storage         
        return cheeseProducerStorage.getUser(walletCheeseProducer);
    }

    
    // Funzione per far visualizzare i dati ai vari utenti esterni 
    function getCheeseProducerInfo(address walletCheeseProducer) external view checkAddress(walletCheeseProducer) returns (uint256, string memory, string memory) {
        
        // Verifico che l'utente esista
        require(this.isUserPresent(walletCheeseProducer), "User not found");

        uint256 id = cheeseProducerStorage.getId(walletCheeseProducer); // Non è necessario, ma viene recuperato per rispettare il controllo in CheeseProducerStorage
        
        string memory fullName = cheeseProducerStorage.getFullName(walletCheeseProducer, id);
        
        string memory email = cheeseProducerStorage.getEmail(walletCheeseProducer, id);

        return (id, fullName, email);
    }

    function getListAddressCheeseProducer() external view returns ( address [ ] memory){
        return cheeseProducerStorage.getListAddress();
    }



//------------------------------------------------------------ Set Function -------------------------------------------------------------------//

    // - Funzione updateBalance() attraverso l'address e l'id, riusciamo a settare il nuovo balance
    function updateCheeseProducerBalance(address walletCheeseProducer, uint256 balance) external   checkAddress(walletCheeseProducer) {
        // Verifico che il Balance sia >0 
        require(balance>0,"Balance Not Valid");
        // Verifico che l'utente esista 
        require(this.isUserPresent(walletCheeseProducer),"User Not Found!");
        // Update Balance 
        cheeseProducerStorage.updateBalance(walletCheeseProducer, balance);
    }


// ------------------------------------------------------------ Change Address Contract of Service -----------------------------------------------------//

    // TODO : Inserire onlyOrg(msg.sender) per verificare che quest'azione possa farla solo L'organizzazione 

    function changeCheeseProducerStorage(address _cheeseProducerStorageNew, address cheeseProducerOrg)private _onlyOrg(cheeseProducerOrg) {
        cheeseProducerStorage = CheeseProducerStorage(_cheeseProducerStorageNew);
    }

    // TODO : Inserire onlyOrg(msg.sender) per verificare che quest'azione possa farla solo L'organizzazione 

    function changeFilieraToken(address _filieraToken, address cheeseProducerOrg) private _onlyOrg(cheeseProducerOrg){
        filieraToken = Filieratoken(_filieraToken);
    }


}
