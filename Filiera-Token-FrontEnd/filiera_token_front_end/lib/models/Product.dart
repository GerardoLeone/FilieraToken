import 'dart:convert';

import 'package:filiera_token_front_end/utils/enums.dart';

abstract class Product {

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.seller
  });

  final int id;
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
    required int id,
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
    
    int id = 1; //TODO:
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
            expirationDate: 
            expirationDate, 
            quantity: quantity, 
            pricePerLitre: pricePerLitre);
  }

  static List<Product> fromJsonToList(String responseBody) {
    final jsonData = jsonDecode(responseBody); // Parse the response body

    // Handle potential parsing errors:
    if (jsonData is! Map<String, dynamic>) {
      // Handle non-JSON data structure or parsing errors (e.g., throwing an error)
      print("Error: Could not parse response as JSON.");
      throw Exception("Failed to parse response: Unexpected data format.");
    }

    // Access the "input" and "milkBatches" arrays based on API structure:
    final milkBatchList = jsonData['input']['milkBatches'] as List<dynamic>;


    // Convert each element in the list into a MilkBatch object:
    final products = milkBatchList.map((milkBatchData) {
      String expirationDate = milkBatchData['scadenza'] as String;
      int quantity = milkBatchData['quantity'] as int;
      double pricePerLitre = double.tryParse(milkBatchData['price'] as String) ?? 0.0;

      // Temporary solution for missing values:
      int id = 1;
      String name = "Partita di Latte";
      String description = "Silos contenente latte, disponibile all'acquisto immediato.";
      String seller = "N.A.";

      return MilkBatch(
          id: id,
          name: name,
          description: description,
          seller: seller,
          expirationDate: expirationDate,
          quantity: quantity,
          pricePerLitre: pricePerLitre);
    }).toList();

    return products;
}


}

class CheeseBlock extends Product {

  CheeseBlock({
    required int id,
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
  
  @override
  Product fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }
}

class CheesePiece extends Product {

  const CheesePiece({
    required int id,
    required String name,
    required String description,
    required String seller,
    required this.price,
    required this.weight,
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
  
  @override
  Product fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }
}
