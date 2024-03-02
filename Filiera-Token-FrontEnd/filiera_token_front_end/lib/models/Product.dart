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
  
  static Product fromJson(Map<String, dynamic> milkBatchData) {
    
    String id = milkBatchData['output'];
    String name = "Partita di Latte";
    String description = "Silos contenente latte, disponibile all'acquisto immediato.";
    String seller = milkBatchData["output1"];
    String expirationDate = milkBatchData['output2'];
    String quantity = milkBatchData['output3'];
    double pricePerLitre = double.parse("0.2");

    return MilkBatch(
            id: id, 
            name: name, 
            description: description, 
            seller: seller, 
            expirationDate: expirationDate, 
            quantity: int.parse(quantity), 
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
  
  static Product fromJson(Map<String, dynamic> cheeseBlockData) {
    
    String id = cheeseBlockData['output'];
    print(id);
    String name = "Partita di Formaggio"; // Changed name
    String description = "Silos contenente formaggio, disponibile all'acquisto immediato."; // Changed description
    String milkBatchId = cheeseBlockData['output1']; // TODO: Replace with function that returns the name of the CheeseProducer from CheeseProducerServiceù
    print(milkBatchId);
    int quantity = int.parse(cheeseBlockData['output3']); // Parsing quantity as int
    print(quantity);
    double price = quantity as double; // Parsing price as double
    String dop = cheeseBlockData['output2'];

    return CheeseBlock(
      id: id, 
      name: name, 
      description: description, 
      seller: milkBatchId, 
      dop: dop, 
      price: double.parse(price), 
      quantity: int.parse(quantity));
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
  
  static Product fromJson(Map<String, dynamic> cheesePiece) {

    String id = cheesePiece['output'];
    String name = "Pezzo di Formaggio";
    String description = "Pezzo di formaggio di alta qualità.";
    String cheeseBlockId = cheesePiece["output1"];
    double price = double.parse(cheesePiece['output2'] as String); // Parsing price as double
    double weight = double.parse(cheesePiece['output3'] as String);

    return CheesePiece(
      id: id, 
      name: name, 
      description: description, 
      seller: cheeseBlockId, 
      price: price, 
      weight: weight);

  }
}
