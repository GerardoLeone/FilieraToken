// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./RetailerStorage.sol";
import "./Filieratoken.sol";


contract RetailerService {

    // Address of Consumer Storage 
    RetailerStorage private retailerStorage;
    
    // Address of Token FT - ERC-20
    Filieratoken private filieraToken;

    // Address of Organization che gestisce gli utenti
    address private  RetailerOrg;
    
    // Evento emesso al momento della cancellazione di un consumatore
    event ConsumerDeleted(address indexed walletRetailer, string message);
    // Evento emesso al momento della registrazione di un consumatore
    event ConsumerRegistered(address indexed walletRetailer, string fullName, string message);

    /**
     * modifier --- OnlyOwner specifica che solo il possessore può effettuare quella chiamata
     */
    modifier onlyOwner(address walletRetailer) {
        require(msg.sender != retailerStorage, "Address Not valid!");
        require(msg.sender != filieraToken, "Address Not valid!" );
        require(msg.sender != RetailerOrg ," Address not Valid, it is organization address");
        require(msg.sender == walletRetailer, "Only the account owner can perform this action");
        _;
    }

    constructor(address _retailerStorage, address _filieraToken) {
        retailerStorage = ConsumerStorage(_retailerStorage);
        filieraToken = Filieratoken(_filieraToken);
        RetailerOrg = msg.sender;
    }

    /**
     * registerRetailer() registra gli utenti della piattaforma che sono Retailer 
     * - Inserisce i dati all'interno della Blockchain
     * - Trasferisce 100 token dal contratto di FilieraToken 
     * - Emette un evento appena l'utente è stato registrato 
     *  */ 
    function registerRetailer(string memory fullName, string memory password, string memory email) external {

        address walletRetailer = msg.sender;        
        //Call function of Storage 
        retailerStorage.addUser(fullName, password, email,walletRetailer);

        filieraToken.transfer(walletRetailer, 100);

        // Emit Event on FireFly 
        emit ConsumerRegistered(walletRetailer, fullName, "Utente e' stato registrato!");
    }

    /**
     * login() effettua la Login con email e password 
     * - Inserisce l'email e la password 
     * - return True se l'utente esiste ed ha accesso con le giuste credenziali 
     * - return False altrimenti 
     */
    function login(string email, string password) view returns(bool) {
        address walletRetailer = msg.sender;
        
        return retailerStorage.loginUser(walletRetailer, email, password);
    }

    /**
     * getRetailerData() otteniamo i dati del Retailer
     * - tramite l'address del Retailer riusciamo a visualizzare anche i suoi dati
     * - Dati sensibili e visibili solo dal Retailer stesso 
     */
    function getRetailerData(address walletRetailer) external onlyOwner view returns (uint256, string memory, string memory, string memory, uint256) {
        // Call function of Storage         
        return retailerStorage.getUser(walletRetailer);
    }



    /**
     * deleteRetailer() elimina un Retailer all'interno del sistema 
     * - Solo l'owner può effettuare l'eliminazione 
     * - msg.sender dovrebbe essere solo quello dell'owner 
     */
    function deleteRetailer(address walletRetailer) external onlyOwner  {
        require(retailerStorage.deleteUser(walletRetailer), "Errore durante la cancellazione");
        // Burn all token 
        filieraToken.burnToken(walletRetailer, filieraToken.balanceOf(walletRetailer));
        // Emit Event on FireFly 
        emit ConsumerDeleted(walletRetailer,"Utente e' stato eliminato!");
    }

// -------------------------------------------------------------------------------- CheeseProducer -----------------------------------------------------------------------//

    /**
     * viewRetailer() inseriamo l'address del Retailer per poter visualizzare i dati meno sensibili del Retailer
     * - Visualizziamo il Retailer ( email , fullname )
     */
    function viewRetailer(address walletRetailer) external view returns(string memory,string memory) {
        // Address dovrebbe essere il ruolo del CheeseProducer 
        address caller = msg.sender;

        require(address(walletRetailer)!=0, "Address Retailer non valido!");
        require(address(caller)!=0, "Address non valido!");

        return retailerStorage.getRetailerToCheeseProducer(walletRetailer);
    }

// --------------------------------------------------------------------------- RetailerInventoryService ----------------------------------------------------//

    function isUserPresent(address walletRetailer) external view returns(bool){
        return retailerStorage.isUserPresent(walletRetailer);
    }



}
