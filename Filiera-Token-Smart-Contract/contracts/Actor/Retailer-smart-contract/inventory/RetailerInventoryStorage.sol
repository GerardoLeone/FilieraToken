// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RetailerInventoryStorage {

    // Address of the organization managing the users
    address private retailerOrg;

    constructor() {
        retailerOrg = msg.sender;
    }

    struct CheesePiece {
        uint256 id; // Cheese Piece ID 
        uint256 price;
        uint256 weight;
    }

    mapping(address => mapping(uint256 => CheesePiece)) private cheesePieces;

    uint256 [] private cheesePieceIdPurchasedList;

    // --------------------------------------------------- Business Function --------------------------------------------------------------------------------------//

    function addCheesePiece(
        address walletRetailer,
        uint256 _id_CheeseBlock,
        uint256 _price,
        uint256 _weight
    ) external returns (uint256, uint256, uint256) {

        uint256 _id = uint256(keccak256(abi.encodePacked(
            _id_CheeseBlock,
            _price,
            _weight,
            walletRetailer,
            block.timestamp
        )));

        // Crea un nuovo Pezzo di formaggio
        CheesePiece memory cheesePiece = CheesePiece({
            id: _id,
            price: _price,
            weight: _weight
        });

        // Inserisce il riferimento all'interno della lista
        cheesePieceIdPurchasedList.push(_id);

        // Inserisce il nuovo Pezzo di formaggio nella lista cheesePieces
        cheesePieces[walletRetailer][_id] = cheesePiece;

        return (cheesePiece.id, cheesePiece.price, cheesePiece.weight);
    }

    function getCheesePiece(address walletRetailer, uint256 _id) external view returns (uint256, uint256, uint256) {

        CheesePiece memory cheesePiece = cheesePieces[walletRetailer][_id];

        return (cheesePiece.id, cheesePiece.price, cheesePiece.weight);
    }

    // Elimina il CheesePiece 
    function deleteCheesePiece(address walletRetailer, uint256 _id) external returns (bool value) {

        delete cheesePieces[walletRetailer][_id];
        // Check CheesePiece in the mapping 
        if (cheesePieces[walletRetailer][_id].id == 0 && deleteCheesePieceIdFromList(_id)) {
            return true;
        } else {
            return false;
        }
    }

    // Verifica che il CheesePiece è già presente 
    function isCheesePiecePresent(address walletRetailer, uint256 _id_CheesePiece) external view returns (bool) {

        require(_id_CheesePiece != 0 && _id_CheesePiece > 0, "ID CheesePiece Non Valido!");

        return cheesePieces[walletRetailer][_id_CheesePiece].id == _id_CheesePiece;
    }

// --------------------------------------------------- Set Function --------------------------------------------------------------------------------------//


    // - Funzione updateCheeseBlockQuantity() aggiorna la quantità del CheeseBlock 
    function updateWeight(
        address walletRetailer,
        uint256 _id_Cheese,
        uint256 _newQuantity
    ) external  {
        
        // Controllo sulla quantita' 
        require(_newQuantity<=cheesePieces[walletRetailer][_id_Cheese].weight,"Controllo della Quantita' da utilizzare non andata a buon fine!");

        cheesePieces[walletRetailer][_id_Cheese].weight = _newQuantity;
    }

    function deleteCheesePieceIdFromList(uint256 _id) internal returns (bool) {
        for (uint256 i = 0; i < cheesePieceIdPurchasedList.length; i++) {
            if (cheesePieceIdPurchasedList[i] == _id) {
                delete cheesePieceIdPurchasedList[i];
                return true;
            }
        }
        return false;
    }


// --------------------------------------------------- Get Function --------------------------------------------------------------------------------------//

    function getPrice(address walletRetailer, uint256 _id) external view returns (uint256) {

        CheesePiece memory cheesePiece = cheesePieces[walletRetailer][_id];
        return cheesePiece.price;
    }

    function getWeight(address walletRetailer, uint256 _id) external view returns (uint256) {

        CheesePiece memory cheesePiece = cheesePieces[walletRetailer][_id];
        return cheesePiece.weight;
    }

    /*
        - Funzione per recuperare tutti i MilKBatchPurchased di un determinato walletCheeseProducer
    */
    function getCheesePieceListPurchasedByRetailer(address walletRetailer) external view returns (CheesePiece[] memory) {
        CheesePiece [ ] memory  cheesePiecePurchasedList  = new CheesePiece[](cheesePieceIdPurchasedList.length);
        
        for (uint256 i=0; i<cheesePieceIdPurchasedList.length; i++){

                uint256 _id = cheesePieceIdPurchasedList[i];
                if(cheesePieces[walletRetailer][_id].id != 0){
                    // Esiste e questo è il MilkBatch dell'Utente 
                    CheesePiece storage new_milkbatchPurchased = cheesePieces[walletRetailer][_id];
                    cheesePiecePurchasedList[i] = new_milkbatchPurchased;
                } 
        }

        return cheesePiecePurchasedList;
    }

    function getAllCheesePieceList(address[] memory retailerListAddress) external view returns (CheesePiece[] memory) {
        
        CheesePiece[] memory cheesePieceList = new CheesePiece[](cheesePieceIdPurchasedList.length);
            
        uint256 t = 0;

        for(uint256 i = 0; i < retailerListAddress.length; i++) {
            
            CheesePiece[] memory cheesePieceListFromUser = this.getCheesePieceListPurchasedByRetailer(retailerListAddress[i]);
                
            for(uint256 j = 0; j < cheesePieceListFromUser.length; j++) {
                CheesePiece memory new_cheesePiece = cheesePieceListFromUser[j];
                cheesePieceList[t] = new_cheesePiece;
                t = t + 1;
            }
        }

        return cheesePieceList;
    }


}
