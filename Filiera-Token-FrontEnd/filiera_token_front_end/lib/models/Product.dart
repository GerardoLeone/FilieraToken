import 'dart:convert';

import 'package:filiera_token_front_end/utils/enums.dart';

/**
 * Classe astratta per i Prodotti.
 * il parametro seller è da impostare solo per i valori restituiti dal Buyer, per il resto delle chiamate rimane inutilizzato.
 */
abstract class Product {

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.seller
  });

  final String id;
  final String name;
  final String description;
  final String seller;

  String getBarcode();

  double getUnitPrice();
  
  Asset getAsset();

  /*
   *  Metodi necessari per frontend
   */
  String getExpirationDate();
  int getQuantity();

  @override
  String toString() => 'Prodotto(id: $id)';

  void updateQuantity(int quantityChange);

}

class MilkBatch extends Product {

  MilkBatch({
    required String id,
    required String name,
    required String description,
    required String seller,
    required this.expirationDate,
    required this.quantity,
    required this.pricePerLitre,
  }) : super(id: id, name: name, description: description, seller: seller);

  final String expirationDate;
  int quantity;
  final double pricePerLitre;

  @override
  String getBarcode() => 'MilkBatch-$id';

  @override
  double getUnitPrice() => pricePerLitre;

  @override
  String toString() => 'MilkBatch(id: $id, scadenza: $expirationDate, '
      'quantità: $quantity, prezzo al litro: $pricePerLitre)';
  
  @override
  Asset getAsset() => Asset.MilkBatch;

  @override
  String getExpirationDate() => expirationDate;

  @override
  int getQuantity() => quantity;
  
  @override
  void updateQuantity(int quantityChange) {
    quantity -= quantityChange;
  }
  
  static Product fromJson(Map<String, dynamic> json) {
    final milkBatchData = json['input'] as Map<String, dynamic>; // Access nested data
    
    String id = json['id'];
    String name = "Partita di Latte";
    String description = "Silos contenente latte, disponibile all'acquisto immediato.";
    String seller = "N.A."; //TODO: funzione che restituisce il nome del MilkHub dal MilkHubService
    String expirationDate = milkBatchData['expirationDate'] as String;
    int quantity = milkBatchData['quantity'] as int;
    double pricePerLitre = milkBatchData['price'] as double; //TODO: gestire il double

    return MilkBatch(
            id: id, 
            name: name, 
            description: description, 
            seller: seller, 
            expirationDate: expirationDate, 
            quantity: quantity, 
            pricePerLitre: pricePerLitre);
  }
}

class CheeseBlock extends Product {

  CheeseBlock({
    required String id,
    required String name,
    required String description,
    required String seller,
    required this.dop,
    required this.price,
    required this.quantity,
  }) : super(id: id, name: name, description: description, seller: seller);

  final String dop;
  final double price;
  int quantity;

  @override
  String getBarcode() => 'Cheese-$id';

  @override
  double getUnitPrice() => price / quantity;

  @override
  String toString() => 'Cheese(id: $id, dop: $dop, prezzo: $price, '
      'quantità: $quantity)';

  @override
  Asset getAsset() => Asset.CheeseBlock;

  @override
  String getExpirationDate() => '';

  @override
  int getQuantity() => quantity;
  
  @override
  void updateQuantity(int quantityChange) {
    quantity -= quantityChange;
  }
  
  static Product fromJson(Map<String, dynamic> json) {
    final cheeseBlockData = json['input'] as Map<String, dynamic>; // Access nested data
    
    String id = json['id'];
    String name = "Partita di Formaggio"; // Changed name
    String description = "Silos contenente formaggio, disponibile all'acquisto immediato."; // Changed description
    String milkBatchId = "N.A."; // TODO: Replace with function that returns the name of the CheeseProducer from CheeseProducerServiceù
    int quantity = int.parse(cheeseBlockData['quantity'] as String); // Parsing quantity as int
    double price = double.parse(cheeseBlockData['price'] as String); // Parsing price as double
    String dop = cheeseBlockData['dop'] as String;

    return CheeseBlock(
      id: id, 
      name: name, 
      description: description, 
      seller: milkBatchId, 
      dop: dop, 
      price: price, 
      quantity: quantity);
  }
}

class CheesePiece extends Product {

  const CheesePiece({
    required String id,
    required String name,
    required String description,
    required String seller,
    required this.price,
    required this.weight
  }) : super(id: id, name: name, description: description, seller: seller);

  final double price;
  final double weight;

  @override
  String getBarcode() => 'CheesePiece-$id';

  @override
  double getUnitPrice() => price / weight;

  @override
  String toString() => 'CheesePiece(id: $id, prezzo: $price, peso: $weight)';

  @override
  Asset getAsset() => Asset.CheesePiece;

  @override
  String getExpirationDate() => '';

  @override
  int getQuantity() => 1;
  
  @override
  void updateQuantity(int quantityChange) {}
  
  static Product fromJson(Map<String, dynamic> json) {
    final cheesePieceData = json['input'] as Map<String, dynamic>;

    String id = json['id'];
    String name = "Pezzo di Formaggio";
    String description = "Pezzo di formaggio di alta qualità.";
    String cheeseBlockId = "N.A.";
    double price = double.parse(cheesePieceData['price'] as String); // Parsing price as double
    double weight = double.parse(cheesePieceData['weight'] as String);

    return CheesePiece(
      id: id, 
      name: name, 
      description: description, 
      seller: cheeseBlockId, 
      price: price, 
      weight: weight);

  }
}
