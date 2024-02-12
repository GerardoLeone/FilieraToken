// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MilkHubInventoryStorage.sol";
import "../MilkHubService.sol";


contract MilkHubInventoryService {

     // Address of Organization che gestisce gli utenti
    address private  MilkHubOrg;

    MilkHubInventoryStorage private milkhubInventoryStorage;

    MilkHubService private milkhubService;

    constructor(address _milkhubInventoryStorage, address _milkhubService){
        MilkHubOrg = msg.sender;
        milkhubInventoryStorage = MilkHubInventoryStorage(_milkhubInventoryStorage);
        milkhubService = MilkHubService(_milkhubService);
    }

    // Eventi per notificare l'aggiunta e l'eliminazione dei dati
    event MilkBatchAdded(address indexed userAddress, string message, string dop, uint256 quantity, uint256 price);
    event MilkBatchDeleted(address indexed userAddress, uint256 indexed id, string message);
    
    // Modifier: 
    // Modifica il comportamento della funzione applicando una particolare condizione e un particolare comportamento aggiuntivo
    modifier onlyIfUserPresent() {

        require(msg.sender != MilkHubOrg, "Address not valid!");
        require(msg.sender != address(milkhubInventoryStorage), "Address not valid of Inventory Storage");
        require(msg.sender != address(milkhubService),"Address not valid of Service");
        require(milkhubService.isUserPresent(msg.sender), "User is not present in data");
        _;
    }

    /* Questa funzione permette di aggiungere : 
       Un prodotto MilkBatch all'inventario da poter mettere in vendita
       
       - Check da effettuare : 
       - Verifica che l'address dell'utente sia registrato 
       - Verifica che l'address dell'utente non sia l'organizzazione che ha deployato il contratto 
       
       - Evento : 
       - milkBatchAdded()
     */
    function addMilkBatch(string memory _scadenza, uint256 _quantity, uint256 _price) external onlyIfUserPresent {
        address walletMilkHub = msg.sender;
        // Verifico che l'address sia diverso da quello di Deploy 
        require(walletMilkHub != MilkHubOrg,"Address non Valido!");
        //Call function of Storage 
        milkhubInventoryStorage.addMilkBatch(walletMilkHub, _scadenza, _quantity, _price);
        // Emissione dell'evento 
        emit MilkBatchAdded(walletMilkHub, "Pezzo di formaggio inserito !", _scadenza, _quantity, _price);
    }

    /**
     * Ottenere le informazioni del milkbatch attraverso : 
     * - ID 
     * */  
    function getMilkBatch(uint256 _id) external  view returns (uint256, string memory, uint256, uint256)  {
        // Retrieve msg.sender 
        address walletMilkHub = msg.sender;

        return milkhubInventoryStorage.getMilkBatch(walletMilkHub,_id);
    }


    /**
     * Eliminare un MilkBatch attraverso l'id 
     * - ID 
     * - Verficare che l'utente che vuole eseguire la transazione sia presente.
     */
    function deleteMilkBatch(uint256 _id) external onlyIfUserPresent returns(bool value) {
        // Retrieve msg.sender 
        address walletMilkHub = msg.sender;

        if(milkhubInventoryStorage.deleteMilkBatch(walletMilkHub,_id)){
            emit MilkBatchDeleted(walletMilkHub,_id,"Pezzo di Formaggio e' stato eleminato");
            return true;
        }else {
            return false;
        }
    }
}