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
}

class MilkBatch extends Product {

  const MilkBatch({
    required int id,
    required String name,
    required String description,
    required String seller,
    required this.expirationDate,
    required this.quantity,
    required this.pricePerLitre,
  }) : super(id: id, name: name, description: description, seller: seller);

  final String expirationDate;
  final int quantity;
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
}

class CheeseBlock extends Product {

  const CheeseBlock({
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
  final int quantity;

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
}
