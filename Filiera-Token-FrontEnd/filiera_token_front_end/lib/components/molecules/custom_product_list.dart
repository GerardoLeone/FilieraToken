import 'package:flutter/material.dart';
import 'package:filiera_token_front_end/models/Product.dart';
import 'package:filiera_token_front_end/components/molecules/custom_card.dart';

class CustomProductList extends StatelessWidget {
  final Future<List<Product>> productList;
  final void Function(BuildContext, Product) onProductTap; // Callback per gestire il tap del prodotto

  const CustomProductList({
    Key? key,
    required this.productList,
    required this.onProductTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: productList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Se il futuro è ancora in attesa, mostra un indicatore di caricamento
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Se si è verificato un errore durante il recupero dei dati, mostra un messaggio di errore
          return Text('Errore: ${snapshot.error}');
        } else {
          // Se il futuro è completato con successo, otterrai la lista di prodotti
          List<Product> products = snapshot.data as List<Product>;
          return SingleChildScrollView(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = 300.0;
                final crossAxisCount = (constraints.maxWidth / cardWidth).floor();

                return SingleChildScrollView(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: cardWidth / (cardWidth * 0.85),
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(context, products[index]);
                    },
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return CustomCard(
      productName: product.name,
      description: product.description,
      expirationDate: (product is MilkBatch) ? product.expirationDate : null,
      seller: product.seller,
      price: product.getUnitPrice(),
      image: product.getAsset(),
      onTap: () => onProductTap(context, product), // Utilizza il callback del prodotto
    );
  }
}
