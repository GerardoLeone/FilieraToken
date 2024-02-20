abstract class Product {

  
  const Product({
    required this.id,
  });

  final int id;

  String getBarcode();

  double getUnitPrice();

  @override
  String toString() => 'Prodotto(id: $id)';
}




class MilkBatch extends Product {
  const MilkBatch({
    required int id,
    required this.scadenza,
    required this.quantity,
    required this.pricePerLitre,
  }) : super(id: id);

  final String scadenza;
  final int quantity;
  final double pricePerLitre;

  @override
  String getBarcode() => 'MilkBatch-$id';

  @override
  double getUnitPrice() => pricePerLitre;

  @override
  String toString() => 'MilkBatch(id: $id, scadenza: $scadenza, '
      'quantità: $quantity, prezzo al litro: $pricePerLitre)';
}

class CheeseBlock extends Product {
  const CheeseBlock({
    required int id,
    required this.dop,
    required this.price,
    required this.quantity,
  }) : super(id: id);

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
}

class CheesePiece extends Product {
  const CheesePiece({
    required int id,
    required this.price,
    required this.weight,
  }) : super(id: id);

  final double price;
  final double weight;

  @override
  String getBarcode() => 'CheesePiece-$id';

  @override
  double getUnitPrice() => price / weight;

  @override
  String toString() => 'CheesePiece(id: $id, prezzo: $price, peso: $weight)';
}
