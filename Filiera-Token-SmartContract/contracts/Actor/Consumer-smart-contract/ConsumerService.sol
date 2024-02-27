// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ConsumerStorage.sol";
import "../../Service/Filieratoken.sol";


contract ConsumerService {

//-------------------------------------------------------------------- Contract Address Service --------------------------------------------------------------------//


    // Address of Consumer Storage 
    ConsumerStorage private consumerStorage;
    
    // Address of Token FT - ERC-20
    Filieratoken private filieraToken;

    // Address of Organization che gestisce gli utenti
    address private  ConsumerOrg;



// --------------------------------------------------------------------- Event of Service ----------------------------------------------------------------//

    // Evento emesso al momento della cancellazione di un consumatore
    event ConsumerDeleted(address indexed walletConsumer, string message);
    // Evento emesso al momento della registrazione di un consumatore
    event ConsumerRegistered(address indexed walletConsumer, string fullName, string message);



//---------------------------------------------------------------------- Constructor ----------------------------------------------------------------------------//    
    constructor(address _consumerStorage, address _filieraToken) {
        consumerStorage = ConsumerStorage(_consumerStorage);
        filieraToken = Filieratoken(_filieraToken);
        ConsumerOrg = msg.sender;
    }

// ------------------------------------------------------------ Modifier Of Service ---------------------------------------------------------------------------------//


    modifier onlyOrg(address sender){
        require(sender == ConsumerOrg,"User Not Authorized!");
        _;
    }

    // Verifica chi effettua la transazione : 
    // Verfica che l'address non sia l'organizzazione 
    // Verfica che l'address non sia lo smart contract del ConsumerStorage e FilieraToken 
    modifier checkAddress(address walletConsumer){

        require(walletConsumer != address(0),"Address is zero");
        require(walletConsumer != address(consumerStorage), "Address is ConsumerStorage Smart Contract!");
        require(walletConsumer != address(filieraToken), "Address is FilieraToken Smart Contract!" );
        require(walletConsumer != ConsumerOrg ,"Organization address");

        _;
    }


//--------------------------------------------------------------- Business Logic -------------------------------------------------------------------------------------------//

    /**
     * registerMilkHub() registra gli utenti della piattaforma che sono Consumer 
     * - Inserisce i dati all'interno della Blockchain
     * - Trasferisce 100 token dal contratto di FilieraToken 
     * - Emette un evento appena l'utente è stato registrato 
     *  */ 
    function registerMilkHub(string memory fullName, string memory password, string memory email, address walletConsumer) external checkAddress(walletConsumer) {

        // Verifica che l'utente è gia' presente 
        require(!(this.isUserPresent(walletConsumer)), "Utente gia' registrato !");

        // Chiama la funzione di Storage 
        consumerStorage.addUser(fullName, password, email, walletConsumer);

        // Autogenera dei token nel balance del Consumer 
        require(filieraToken.registerUserWithToken(address(walletConsumer), 100),"Transfer Token not Valid!");

        // Emette l'evento della registrazione dell'utente
        emit ConsumerRegistered(walletConsumer, fullName, "Utente Consumer e' stato registrato!");
    }

    /**
     * login() effettua la Login con email e password 
     * - Inserisce l'email e la password 
     * - return True se l'utente esiste ed ha accesso con le giuste credenziali 
     * - return False altrimenti 
     */
    function login(address walletConsumer, string memory email, string memory password) external view checkAddress(walletConsumer)  returns(bool) {

        // Verifichiamo che l'utente è presente 
        require(this.isUserPresent(walletConsumer),"Utente non e' presente!");
        
        return consumerStorage.loginUser(walletConsumer, email, password);
    }


    /**
     * deleteMilkHub() elimina un Consumer all'interno del sistema 
     * - Solo l'owner può effettuare l'eliminazione 
     * - msg.sender dovrebbe essere solo quello dell'owner 
     */
    function deleteMilkHub(address walletConsumer, uint256 _id) external checkAddress(walletConsumer)  {
        
        // Verifico che l'utente è presente 
        require(this.isUserPresent(walletConsumer), "Utente non e' presente!");
        // Restituisce l'id del Consumer tramite il suo address wallet
        require(consumerStorage.getId(walletConsumer) == _id , "Utente non Autorizzato!");
        // Effettuo la cancellazione dell'utente 
        require(consumerStorage.deleteUser(walletConsumer), "Errore durante la cancellazione");
        // Burn all token ( elimina i token che sono in circolazione, di un utente che non effettua transazioni ) 
        filieraToken.burnToken(walletConsumer, filieraToken.balanceOf(walletConsumer));
        // Emit Event on FireFly 
        emit ConsumerDeleted(walletConsumer,"Utente e' stato eliminato!");
    }

// --------------------------------------------------------------------------- MilkHubInventoryService ----------------------------------------------------//

    function isUserPresent(address walletConsumer) external view returns(bool){
        
        return consumerStorage.isUserPresent(walletConsumer);
    }



//----------------------------------------------------------------------------- Get Function ----------------------------------------------------------------------//

    /**
        -  Funzione getMilkHubId() attraverso l'address del Consumer siamo riusciti ad ottenere il suo ID
    */
    function getMilkHubId(address walletConsumer) external view checkAddress(walletConsumer)  returns (uint256){
        
        return consumerStorage.getId(walletConsumer);
    }

    
    /**
        - Funzione getFullName() attraverso l'address del Consumer riusciamo a recuperare il suo FullName
    */
    function getMilkHubFullName(address walletConsumer,uint256 _id) external view checkAddress(walletConsumer) returns(string memory){

        return consumerStorage.getFullName(walletConsumer,_id);
    }

    /**
        - Funzione getEmail() attraverso l'address del Consumer riusciamo a recuperare la sua Email 
    */
    function getMilkHubEmail(address walletConsumer, uint256 _id) external view checkAddress(walletConsumer) returns(string memory){
        
        return consumerStorage.getEmail(walletConsumer,_id);
    }

    /**
        - Funzione getBalance() attraverso l'address del Consumer riusciamo a recuperare il suo Balance
    */
    function getMilkHubBalance(address walletConsumer, uint256 _id) external view checkAddress(walletConsumer)  returns(uint256){

        return consumerStorage.getBalance(walletConsumer,_id);
    }

    /**
     * getMilkHubData() otteniamo i dati del Consumer
     * - tramite l'address del Consumer riusciamo a visualizzare anche i suoi dati
     * - Dati sensibili e visibili solo dal Consumer stesso 
     */
    function getMilkHubData(address walletConsumer, uint256 _id) external checkAddress(walletConsumer) view returns (uint256, string memory, string memory, string memory, uint256) {
        // Verifico che l'utente è presente 
        require(this.isUserPresent(walletConsumer), "Utente non e' presente!");
        // Restituisce l'id del Consumer tramite il suo address wallet
        require(consumerStorage.getId(walletConsumer) == _id , "Utente non Autorizzato!");
        // Call function of Storage         
        return consumerStorage.getUser(walletConsumer);
    }

    
    // Funzione per far visualizzare i dati ai vari utenti esterni 
    function getMilkHubInfo(address walletConsumer) external view checkAddress(walletConsumer) returns (uint256, string memory, string memory) {
        
        // Verifico che l'utente esista
        require(this.isUserPresent(walletConsumer), "User not found");

        uint256 id = consumerStorage.getId(walletConsumer); // Non è necessario, ma viene recuperato per rispettare il controllo in ConsumerStorage
        
        string memory fullName = consumerStorage.getFullName(walletConsumer, id);
        
        string memory email = consumerStorage.getEmail(walletConsumer, id);

        return (id, fullName, email);
    }

    function getListAddressMilkHub() external view returns ( address [ ] memory){
        return consumerStorage.getListAddress();
    }

//------------------------------------------------------------ Set Function -------------------------------------------------------------------//

    // - Funzione updateBalance() attraverso l'address e l'id, riusciamo a settare il nuovo balance
    function updateMilkHubBalance(address walletConsumer, uint256 balance) external checkAddress(walletConsumer) {
        // Verifico che il Balance sia >0 
        require(balance>0,"Balance Not Valid");
        // Verifico che l'utente esista 
        require(this.isUserPresent(walletConsumer),"User Not Found!");
        // Update Balance 
        consumerStorage.updateBalance(walletConsumer, balance);
    }


// ------------------------------------------------------------ Change Address Contract of Service -----------------------------------------------------//


    function changeMilkHubStorage(address _milkhubStorageNew)private  {
        consumerStorage = ConsumerStorage(_milkhubStorageNew);
    }


    function changeFilieraToken(address _filieraToken)private {
        filieraToken = Filieratoken(_filieraToken);
    }


}
