import 'package:filiera_token_front_end/components/molecules/custom_product_list.dart';
import 'package:filiera_token_front_end/components/organisms/User-Profile/ProductBuy/dialog_product_details.dart';
import 'package:filiera_token_front_end/components/organisms/User-Profile/ProductBuy/dialog_product_purchase.dart';
import 'package:filiera_token_front_end/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:filiera_token_front_end/components/molecules/custom_nav_bar.dart';

class HomePageUser extends StatefulWidget {
  const HomePageUser({Key? key}) : super(key: key);

  @override
  State<HomePageUser> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageUser> {

  // Lista di prodotti fittizia
  final List<Product> products = [
    MilkBatch(id: 1, name: "Partita di Latte 1", description: "Descrizione partita di latte 1", seller: "Milk Hub 1", expirationDate: "10-01-2025", quantity: 30, pricePerLitre: 3),
    MilkBatch(id: 2, name: "Partita di Latte 2", description: "Descrizione partita di latte 2", seller: "Milk Hub 2", expirationDate: "10-05-2025", quantity: 22, pricePerLitre: 2),
    MilkBatch(id: 1, name: "Partita di Latte 1", description: "Descrizione partita di latte 1", seller: "Milk Hub 1", expirationDate: "10-01-2025", quantity: 30, pricePerLitre: 3),
    MilkBatch(id: 2, name: "Partita di Latte 2", description: "Descrizione partita di latte 2", seller: "Milk Hub 2", expirationDate: "10-05-2025", quantity: 22, pricePerLitre: 2),
    MilkBatch(id: 1, name: "Partita di Latte 1", description: "Descrizione partita di latte 1", seller: "Milk Hub 1", expirationDate: "10-01-2025", quantity: 30, pricePerLitre: 3),
    MilkBatch(id: 2, name: "Partita di Latte 2", description: "Descrizione partita di latte 2", seller: "Milk Hub 2", expirationDate: "10-05-2025", quantity: 22, pricePerLitre: 2),
    MilkBatch(id: 1, name: "Partita di Latte 1", description: "Descrizione partita di latte 1", seller: "Milk Hub 1", expirationDate: "10-01-2025", quantity: 30, pricePerLitre: 3),
    MilkBatch(id: 2, name: "Partita di Latte 2", description: "Descrizione partita di latte 2", seller: "Milk Hub 2", expirationDate: "10-05-2025", quantity: 22, pricePerLitre: 2),

    CheeseBlock(id: 3, name: "Blocco di Formaggio 1", description: "Descrizione blocco di formaggio 3", seller: "Cheese Producer 1", dop: "dop", price: 500, quantity: 1),
    CheeseBlock(id: 4, name: "Blocco di Formaggio 2", description: "Descrizione blocco di formaggio 4", seller: "Cheese Producer 2", dop: "dop", price: 550, quantity: 2),
    CheeseBlock(id: 3, name: "Blocco di Formaggio 1", description: "Descrizione blocco di formaggio 3", seller: "Cheese Producer 1", dop: "dop", price: 500, quantity: 1),
    CheeseBlock(id: 4, name: "Blocco di Formaggio 2", description: "Descrizione blocco di formaggio 4", seller: "Cheese Producer 2", dop: "dop", price: 550, quantity: 2),
    CheeseBlock(id: 3, name: "Blocco di Formaggio 1", description: "Descrizione blocco di formaggio 3", seller: "Cheese Producer 1", dop: "dop", price: 500, quantity: 1),
    CheeseBlock(id: 4, name: "Blocco di Formaggio 2", description: "Descrizione blocco di formaggio 4", seller: "Cheese Producer 2", dop: "dop", price: 550, quantity: 2),

    CheesePiece(id: 5, name: "Pezzo di Formaggio 1", description: "Descrizione pezzo di formaggio 5", seller: "Retailer 1", price: 10, weight: 1),
    CheesePiece(id: 6, name: "Pezzo di Formaggio 2", description: "Descrizione pezzo di formaggio 6", seller: "Retailer 2", price: 15, weight: 2),
    CheesePiece(id: 5, name: "Pezzo di Formaggio 1", description: "Descrizione pezzo di formaggio 5", seller: "Retailer 1", price: 10, weight: 1),
    CheesePiece(id: 6, name: "Pezzo di Formaggio 2", description: "Descrizione pezzo di formaggio 6", seller: "Retailer 2", price: 15, weight: 2),
    CheesePiece(id: 5, name: "Pezzo di Formaggio 1", description: "Descrizione pezzo di formaggio 5", seller: "Retailer 1", price: 10, weight: 1),
    CheesePiece(id: 6, name: "Pezzo di Formaggio 2", description: "Descrizione pezzo di formaggio 6", seller: "Retailer 2", price: 15, weight: 2),

  ];

  // Indice della pagina corrente
  int currentPage = 0;

  CustomAppBar buildNavBar(BuildContext context){
    return CustomAppBar(title:"FilieraToken-Shop",
            leading: Image.asset('../assets/favicon.png'),
            actions: [
              // Button -> Profile 
                ElevatedButton(
                        child: const Text('Profile'),
                        /// TODO :Update Route Logic 
                        onPressed: () => context.go('/home-page-user/profile'),
                        ),
              SizedBox(width: 20),
              // Button -> Logout -> Home Page Filiera Token 
                ElevatedButton(
                        child: const Text('Logout'),
                        onPressed: () => context.go('/'),
                        )
            ], automaticallyImplyLeading: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildNavBar(context),
      body: CustomProductList(products: products, onProductTap: handleProductTap),
    );
  }

  void handleProductTap(BuildContext context, Product product) {
    // Fai qualcosa in base alla pagina in cui ti trovi
    print("Prodotto ${product.name} cliccato!");
    // Esegui azioni diverse in base alla pagina
    /*DialogProductDetails.show(
      context, 
      product,
      PurchaseDialog(product: product));*/
  }
}