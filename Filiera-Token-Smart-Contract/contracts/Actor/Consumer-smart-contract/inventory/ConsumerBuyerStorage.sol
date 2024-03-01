// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Smart Contract per lo storage dei MilkHub acquistati dai ConsumerBuyer
contract ConsumerBuyerStorage {

    // Address of Organization che gestisce gli utenti
    address private consumerBuyerOrg;

    constructor() {
        consumerBuyerOrg = msg.sender;
    }

    struct CheesePiece {
        uint256 id; // Generato nuovo per il ConsumerBuyer
        address walletRetailer; // Address del Wallet del Retailer
        uint256 price;
        uint256 weight;
    }

    mapping(address => mapping(uint256 => CheesePiece)) private purchasedCheesePieces; // Map of Alla CheesePiece Buyed 

    mapping(address => uint256[]) private userCheesePieceIds;



    //--------------------------------------------------------------- Business Logic Service -----------------------------------------------------------------------------------------//

    function addCheesePiece(
        address _walletConsumerBuyer,
        address _walletRetailer, // Riferimento al wallet del Retailer
        uint256 _id,
        uint256 _price,
        uint256 _weight
    ) external returns (uint256 id_CheesePiece_Acquistato, uint256 price, uint256 weight) {

        CheesePiece storage cheesePieceControl = purchasedCheesePieces[_walletConsumerBuyer][_id];
        require(cheesePieceControl.id == 0, "CheesePiece gia' presente!");

        // Crea un nuovo CheesePiece
        CheesePiece memory cheesePiece = CheesePiece({
            id: _id,
            walletRetailer: _walletRetailer,
            price: _price,
            weight: _weight
        });

        // Inserisce il nuovo CheesePiece nella lista purchasedCheesePieces
        purchasedCheesePieces[_walletConsumerBuyer][_id] = cheesePiece;

        //Inserisci l'id all'interno della Lista
        purchasedCheesePieceListIdForSingleConsumer[_walletConsumerBuyer].push(_id);

        return (
            purchasedCheesePieces[_walletConsumerBuyer][_id].id,
            purchasedCheesePieces[_walletConsumerBuyer][_id].price,
            purchasedCheesePieces[_walletConsumerBuyer][_id].weight
            );
    }

    function getCheesePiece(address walletConsumerBuyer, uint256 _id_CheesePieceAcquistato) external view returns (uint256, address, uint256, uint256) {
        CheesePiece memory cheesePiece = purchasedCheesePieces[walletConsumerBuyer][_id_CheesePieceAcquistato];
        
        return (cheesePiece.id, cheesePiece.walletRetailer, cheesePiece.price, cheesePiece.weight);
    }

    function isCheesePiecePresent(address walletConsumerBuyer, uint256 _id_CheesePieceAcquistato) external view returns(bool) {
        require(_id_CheesePieceAcquistato != 0 && _id_CheesePieceAcquistato > 0, "ID CheesePiece Not Valid!");
        
        return purchasedCheesePieces[walletConsumerBuyer][_id_CheesePieceAcquistato].id != 0;
    }

    function getWeight(address walletConsumerBuyer, uint256 _id) external view returns (uint256) {
        return purchasedCheesePieces[walletConsumerBuyer][_id].weight;
    }

    function getPrice(address walletConsumerBuyer, uint256 _id) external view returns (uint256) {
        return purchasedCheesePieces[walletConsumerBuyer][_id].price;
    }

    function getWalletRetailer(address walletConsumerBuyer, uint256 _id) external view returns (address) {
        return purchasedCheesePieces[walletConsumerBuyer][_id].walletRetailer;
    }
    
    /*
    * Restituisce la Lista di tutti gli ID dei prodotti di un determinato utente
    */
    function getListCheesePieseIdPurchasedByConsumer(address walletConsumer)external view returns (uint256[] memory){
        return purchasedCheesePieceListIdForSingleConsumer[walletConsumer];
    }
}
