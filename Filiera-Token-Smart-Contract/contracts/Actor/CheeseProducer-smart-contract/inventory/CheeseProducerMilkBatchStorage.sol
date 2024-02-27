// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//Smart Contract per lo storage dei MilkHub acquistati dal CheeseProducer
contract CheeseProducerMilkBatchStorage {

    // Address of Organization che gestisce gli utenti
    address private cheeseProducerOrg;

    constructor() {
        cheeseProducerOrg = msg.sender;
    }

    struct MilkBatch {
        uint256 id; // Generato nuovo per il CheeseProducer 
        uint256 id_MilkBatch; // id di riferimento del MilkBatch 
        address walletMilkHub; // Address del Wallet del MilkHub 
        string expirationDate; // Data di scadenza 
        uint256 quantity; // Quantità da acquistare 
    }

    mapping(address => mapping(uint256 => MilkBatch)) private purchasedMilkBatches;

    uint256 [] private milkBatchIdPurchasedList;


//--------------------------------------------------------------- Business Logic Service -----------------------------------------------------------------------------------------//


    /**
    *
    * Funzione addMilkBatch() -> Utilizzata dal Transaction Manager per poter inserire il MilkBatch Acquistato 
    * Scollego questa logica, ammettendo che il CheeseProducer può testare la logica di conversione 
    * params : 
    * - walletCheeseProducer -> mi serve per il mapping 
    * - walletMilkHub -> mi serve per creare il nuovo elemento  
    * - id_milkBatch -> mi serve per il riferimento all'elemento acquistato
    */
    function addMilkBatch( 
        
            address _walletCheeseProducer, 
            address _walletMilkHub, // Riferimento al wallet del MilkHub 
            uint256 _id_MilkBatch, // riferimento al prodotto di MilkBatch 
            string memory _expirationDate,
            uint256 _quantity
        
        ) external returns (uint256 id_MilkBatch_Acquistato, string memory expDate, uint256 quantityAcquistata){

        uint256 _id = uint256(keccak256(abi.encodePacked(
            _expirationDate,
            _quantity,
            _walletCheeseProducer,
            _walletMilkHub,
            _id_MilkBatch,
            block.timestamp // inserimento di questo attributo per rendere l'acquisto unico nel suo genere 
            // l'articolo in questo modo può essere riacquistato dallo stesso cheeseProducer un'altra volta 
        )));


        //Crea una nuova Partita di Latte
        MilkBatch memory milkBatch = MilkBatch({
            id: _id,
            id_MilkBatch: _id_MilkBatch,
            walletMilkHub: _walletMilkHub,
            expirationDate: _expirationDate,
            quantity: _quantity
        });

        //Inserisce la nuova Partita di Latte nella lista purchasedMilkBatches
        purchasedMilkBatches[_walletCheeseProducer][_id] = milkBatch;
        // Inserisce il riferimento all'interno della lista
        milkBatchIdPurchasedList.push(_id);

        return (purchasedMilkBatches[_walletCheeseProducer][_id].id, purchasedMilkBatches[_walletCheeseProducer][_id].expirationDate, purchasedMilkBatches[_walletCheeseProducer][_id].quantity);

    }


    function getMilkBatch(address walletCheeseProducer, uint256 _id_MilkBatchAcquistato) external view returns (uint256, address, string memory, uint256) {

        MilkBatch memory milkBatch = purchasedMilkBatches[walletCheeseProducer][_id_MilkBatchAcquistato];

        return (milkBatch.id, milkBatch.walletMilkHub, milkBatch.expirationDate, milkBatch.quantity);
    }


    /**
    * Funzione per la verifica dell'esistenza del prodotto MilkBatch acquistato 
    * - ritorna TRUE se esiste 
    * - ritorna FALSe se non esiste 
    * - effettua il controllo sull'uguaglianza dell'id del MilkBatch Acquistato
    */
    function isMilkBatchPresent(address walletCheeseProducer, uint256 _id_MilkBatchAcquistato)external view returns(bool){
        require( _id_MilkBatchAcquistato !=0 && _id_MilkBatchAcquistato>0,"ID MilkBatch Not Valid!");

        return purchasedMilkBatches[walletCheeseProducer][_id_MilkBatchAcquistato].id == _id_MilkBatchAcquistato;
    }

// -------------------------------------------------------------- Set Function ------------------------------------------------------------------------------------------//



    // - Funzione updateMilkBatchQuantity() aggiorna la quantità del MilkBatch 
    function updateMilkBatchQuantity(address walletCheeseProducer, uint256 _id, uint256 _newQuantity) external  {
        // Controllo sulla quantita' 
        require(_newQuantity<=purchasedMilkBatches[walletCheeseProducer][_id].quantity,"Controllo della Quantita' da utilizzare non andata a buon fine!");

        purchasedMilkBatches[walletCheeseProducer][_id].quantity = _newQuantity;
    }


// -------------------------------------------------------------- Get Function ------------------------------------------------------------------------------------------//



    function getExpirationDate(address walletCheeseProducer, uint256 _id) external view returns(string memory) {

        MilkBatch memory milkBatch = purchasedMilkBatches[walletCheeseProducer][_id];
        return milkBatch.expirationDate;
    }

    function getQuantity(address walletCheeseProducer, uint256 _id) external view returns(uint256) {

        MilkBatch memory milkBatch = purchasedMilkBatches[walletCheeseProducer][_id];
        return milkBatch.quantity;        
    }

    function getWalletMilkHub(address walletCheeseProducer, uint256 _id) external view returns(address) {

        MilkBatch memory milkBatch = purchasedMilkBatches[walletCheeseProducer][_id];
        return milkBatch.walletMilkHub;
    }

    function getId(address walletCheeseProducer, uint256 _id) external view returns(uint256) {

        return purchasedMilkBatches[walletCheeseProducer][_id].id;
    }

    /*
        - Funzione per recuperare tutti i MilKBatchPurchased di un determinato walletCheeseProducer
    */
    function getMilkBatchListPurchasedByCheeseProducer(address walletCheeseProducer) external view returns (MilkBatch[] memory) {
        MilkBatch [ ] memory  milkBatchPurchasedList  = new MilkBatch[](milkBatchIdPurchasedList.length);
        
        for (uint256 i=0; i<milkBatchIdPurchasedList.length; i++){

                uint256 _id = milkBatchIdPurchasedList[i];
                if(purchasedMilkBatches[walletCheeseProducer][_id].id != 0){
                    // Esiste e questo è il MilkBatch dell'Utente 
                    MilkBatch storage new_milkbatchPurchased = purchasedMilkBatches[walletCheeseProducer][_id];
                    milkBatchPurchasedList[i] = new_milkbatchPurchased;
                } 
        }

        return milkBatchPurchasedList;
    }



// -------------------------------------------------------------- Check Function ------------------------------------------------------------------------------------------//


    function checkMilkBatch(address walletCheeseProducer, uint256 _id, uint256 _quantityToTransform) external view returns(bool) {
        require(purchasedMilkBatches[walletCheeseProducer][_id].id == _id, "Partita di Latte non presente!");

        MilkBatch storage milkBatchObj = purchasedMilkBatches[walletCheeseProducer][_id];
            
        require(milkBatchObj.quantity >= _quantityToTransform, "Quantity not Valid!");
        return true;    
    }


    function checkQuantity(address walletCheeseProducer,  uint256 _id, uint256 _quantityToTransform ) external view returns(bool){
        
        MilkBatch storage milkBatchObj = purchasedMilkBatches[walletCheeseProducer][_id];
            
        require(milkBatchObj.quantity >= _quantityToTransform, "Quantity not Valid!");

        return true;    
    }
    
}