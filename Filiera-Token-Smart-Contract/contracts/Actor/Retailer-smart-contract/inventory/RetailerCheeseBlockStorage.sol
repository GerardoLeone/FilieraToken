// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//Smart Contract per lo storage dei MilkHub acquistati dal CheeseProducer
contract RetailerCheeseBlockStorage {

    // Address of Organization che gestisce gli utenti
    address private RetailerOrg;

    constructor() {
        RetailerOrg = msg.sender;
    }

    struct Cheese {
        uint256 id; // Generato nuovo per il Retailer 
        uint256 id_CheeseBlock; // id di riferimento del CheeseBlock 
        address walletCheeseProducer; // Address del Wallet del CheeseProducer
        string dop; 
        uint256 quantity; // Quantità da acquistare 
    }

    mapping(address => mapping(uint256 => Cheese)) private purchasedCheeseBlocks;


//--------------------------------------------------------------- Business Logic Service -----------------------------------------------------------------------------------------//


    /**
    *
    * Funzione addCheese() -> Utilizzata dal Transaction Manager per poter inserire il Cheese Acquistato 
    * Scollego questa logica, ammettendo che il CheeseProducer può testare la logica di conversione 
    * params : 
    * - walletCheeseProducer -> mi serve per il mapping 
    * - walletCheeseProducer -> mi serve per creare il nuovo elemento  
    * - id_cheese -> mi serve per il riferimento all'elemento acquistato
    */
    function addCheeseBlock( 
        
            address _walletRetailer, 
            address _walletCheeseProducer, // Riferimento al wallet del MilkHub 
            uint256 _id_CheeseBlock, // riferimento al prodotto di Cheese
            string memory dop, // attributo del formaggio  
            uint256 _quantity //Quantità acquisita
        
        ) external returns (
            uint256 id_CheeseBlock_Acquistato,
            string memory dopCheese,
            uint256 quantityAcquistata 
        ){

        uint256 _id = uint256(keccak256(abi.encodePacked(
            _quantity,
            dop,
            _walletRetailer,
            _walletCheeseProducer,
            _id_CheeseBlock,
            block.timestamp // inserimento di questo attributo per rendere l'acquisto unico nel suo genere 
            // l'articolo in questo modo può essere riacquistato dallo stesso cheeseProducer un'altra volta 
        )));


        Cheese storage cheeseControl = purchasedCheeseBlocks[_walletRetailer][_id];
        require( cheeseControl.id == 0, "Partita di Latte gia' presente!");

        //Crea una nuova Partita di Latte
        Cheese memory cheese = Cheese({
            id: _id,
            dop:dop,
            id_CheeseBlock: _id_CheeseBlock,
            walletCheeseProducer: _walletCheeseProducer,
            quantity: _quantity
        });

        //Inserisce la nuova Partita di Latte nella lista purchasedCheeseBlocks
        purchasedCheeseBlocks[_walletRetailer][_id] = cheese;

        return (cheese.id, cheese.dop, cheese.quantity);

    }


    function getCheeseBlock(address walletRetailer, uint256 _id_CheeseBlockAcquistato) external view returns (uint256, address,string memory, uint256) {

        Cheese memory cheese = purchasedCheeseBlocks[walletRetailer][_id_CheeseBlockAcquistato];

        return (cheese.id, cheese.walletCheeseProducer, cheese.dop, cheese.quantity);
    }


    /**
    * Funzione per la verifica dell'esistenza del prodotto Cheese acquistato 
    * - ritorna TRUE se esiste 
    * - ritorna FALSe se non esiste 
    * - effettua il controllo sull'uguaglianza dell'id del Cheese Acquistato
    */
    function isCheesePresent(address walletRetailer, uint256 _id_CheeseBlockAcquistato)external view returns(bool){
        require( _id_CheeseBlockAcquistato !=0 && _id_CheeseBlockAcquistato>0,"ID Cheese Not Valid!");

        return purchasedCheeseBlocks[walletRetailer][_id_CheeseBlockAcquistato].id == _id_CheeseBlockAcquistato;
    }

// -------------------------------------------------------------- Set Function ------------------------------------------------------------------------------------------//



    // - Funzione updateCheeseQuantity() aggiorna la quantità del Cheese 
    function updateCheeseQuantity(address walletRetailer, uint256 _id, uint256 _newQuantity) external  {
        // Controllo sulla quantita' 
        require(_newQuantity<=purchasedCheeseBlocks[walletRetailer][_id].quantity,"Controllo della Quantita' da utilizzare non andata a buon fine!");

        purchasedCheeseBlocks[walletRetailer][_id].quantity = _newQuantity;
    }


// -------------------------------------------------------------- Get Function ------------------------------------------------------------------------------------------//

    function getDop(address walletRetailer, uint256 _id_cheeseBlockAcquistato) external view returns(string memory) {

        Cheese memory cheese = purchasedCheeseBlocks[walletRetailer][_id_cheeseBlockAcquistato];
        return cheese.dop;
    }


    function getQuantity(address walletRetailer, uint256 _id) external view returns(uint256) {

        Cheese memory cheese = purchasedCheeseBlocks[walletRetailer][_id];
        return cheese.quantity;        
    }

    function getWalletCheeseProducer(address walletRetailer, uint256 _id) external view returns(address) {

        Cheese memory cheese = purchasedCheeseBlocks[walletRetailer][_id];
        return cheese.walletCheeseProducer;
    }

    function getId(address walletRetailer, uint256 _id) external view returns(uint256) {

        return purchasedCheeseBlocks[walletRetailer][_id].id;
    }


// -------------------------------------------------------------- Check Function ------------------------------------------------------------------------------------------//


    function checkCheese(address walletRetailer, uint256 _id, uint256 _quantityToTransform) external view returns(bool) {
        require(purchasedCheeseBlocks[walletRetailer][_id].id == _id, "Partita di Latte non presente!");

        Cheese storage cheeseObj = purchasedCheeseBlocks[walletRetailer][_id];
            
        require(cheeseObj.quantity >= _quantityToTransform, "Quantity not Valid!");
        return true;    
    }


    function checkQuantity(address walletRetailer,  uint256 _id, uint256 _quantityToTransform ) external view returns(bool){
        
        Cheese storage cheeseObj = purchasedCheeseBlocks[walletRetailer][_id];
            
        require(cheeseObj.quantity >= _quantityToTransform, "Quantity not Valid!");

        return true;    
    }
    
}