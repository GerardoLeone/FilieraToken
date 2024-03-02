import 'package:filiera_token_front_end/components/molecules/custom_loading_bar.dart';
import 'package:filiera_token_front_end/components/molecules/custom_nav_bar.dart';
import 'package:filiera_token_front_end/components/molecules/custom_product_list.dart';
import 'package:filiera_token_front_end/components/molecules/dialog/dialog_product_details.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/product_buy_profile/components/custom_menu_product_buyed.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/services/secure_storage_service.dart';
import 'package:filiera_token_front_end/models/Product.dart';
import 'package:filiera_token_front_end/models/User.dart';
import 'package:filiera_token_front_end/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

//Prodotti acquistati
class UserProfileProductBuyed extends StatefulWidget {

  
  const UserProfileProductBuyed({Key? key, required String userType, required String idUser}) : super(key: key);

  @override
  State<UserProfileProductBuyed> createState() => _UserProfileProductBuyedState();
  
}

class _UserProfileProductBuyedState extends State<UserProfileProductBuyed> with SingleTickerProviderStateMixin{

  late AnimationController _drawerSlideController;

  late SecureStorageService secureStorageService;

  User? user;

  @override
  void initState() {
    super.initState();

    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    final storage = GetIt.I.get<SecureStorageService>();
    if(storage!=null){
      print("storage non è nullo!");
      secureStorageService = storage;
      _fetch_Data();
      
    }
  }

  Future<void> _fetch_Data() async {
  final retrievedUser = await secureStorageService.get();
  if (retrievedUser != null) {
    setState(() {
      user = retrievedUser;
    });
    print("Type of User : ${user!.type.name}");
    print("User is Alive!");
  }
}

  @override
  void dispose() {
    _drawerSlideController.dispose();
    super.dispose();
  }

  bool _isDrawerOpen() {
    return _drawerSlideController.value == 1.0;
  }

  bool _isDrawerOpening() {
    return _drawerSlideController.status == AnimationStatus.forward;
  }

  bool _isDrawerClosed() {
    return _drawerSlideController.value == 0.0;
  }

  void _toggleDrawer() {
    if (_isDrawerOpen() || _isDrawerOpening()) {
      _drawerSlideController.reverse();
    } else {
      _drawerSlideController.forward();
    }
  }


  // Lista di prodotti fittizia
  final List<Product> products = [
    /*MilkBatch(id: 1, name: "Partita di Latte 1", description: "Descrizione partita di latte 1", seller: "Milk Hub 1", expirationDate: "10-01-2025", quantity: 30, pricePerLitre: 3),
    MilkBatch(id: 2, name: "Partita di Latte 2", description: "Descrizione partita di latte 2", seller: "Milk Hub 2", expirationDate: "10-05-2025", quantity: 22, pricePerLitre: 2),
    MilkBatch(id: 1, name: "Partita di Latte 1", description: "Descrizione partita di latte 1", seller: "Milk Hub 1", expirationDate: "10-01-2025", quantity: 30, pricePerLitre: 3),
    MilkBatch(id: 2, name: "Partita di Latte 2", description: "Descrizione partita di latte 2", seller: "Milk Hub 2", expirationDate: "10-05-2025", quantity: 22, pricePerLitre: 2),
    MilkBatch(id: 1, name: "Partita di Latte 1", description: "Descrizione partita di latte 1", seller: "Milk Hub 1", expirationDate: "10-01-2025", quantity: 30, pricePerLitre: 3),
    MilkBatch(id: 2, name: "Partita di Latte 2", description: "Descrizione partita di latte 2", seller: "Milk Hub 2", expirationDate: "10-05-2025", quantity: 22, pricePerLitre: 2),
*/
    MilkBatch(id: "1", name: "Partita di Latte 1", description: "Descrizione partita di latte 1", seller: "Milk Hub 1", expirationDate: "10-01-2025", quantity: 30, pricePerLitre: 3),
    MilkBatch(id: "2", name: "Partita di Latte 2", description: "Descrizione partita di latte 2", seller: "Milk Hub 2", expirationDate: "10-05-2025", quantity: 22, pricePerLitre: 2),
    /*CheeseBlock(id: 3, name: "Blocco di Formaggio 1", description: "Descrizione blocco di formaggio 3", seller: "Cheese Producer 1", dop: "dop", price: 500, quantity: 1),
    CheeseBlock(id: 3, name: "Blocco di Formaggio 1", description: "Descrizione blocco di formaggio 3", seller: "Cheese Producer 1", dop: "dop", price: 500, quantity: 1),
    CheeseBlock(id: 4, name: "Blocco di Formaggio 2", description: "Descrizione blocco di formaggio 4", seller: "Cheese Producer 2", dop: "dop", price: 550, quantity: 2),
    CheeseBlock(id: 4, name: "Blocco di Formaggio 2", description: "Descrizione blocco di formaggio 4", seller: "Cheese Producer 2", dop: "dop", price: 550, quantity: 2),
    CheeseBlock(id: 3, name: "Blocco di Formaggio 1", description: "Descrizione blocco di formaggio 3", seller: "Cheese Producer 1", dop: "dop", price: 500, quantity: 1),
    CheeseBlock(id: 4, name: "Blocco di Formaggio 2", description: "Descrizione blocco di formaggio 4", seller: "Cheese Producer 2", dop: "dop", price: 550, quantity: 2),

    CheesePiece(id: 5, name: "Pezzo di Formaggio 1", description: "Descrizione pezzo di formaggio 5", seller: "Retailer 1", price: 10, weight: 1),
    CheesePiece(id: 6, name: "Pezzo di Formaggio 2", description: "Descrizione pezzo di formaggio 6", seller: "Retailer 2", price: 15, weight: 2),
    CheesePiece(id: 5, name: "Pezzo di Formaggio 1", description: "Descrizione pezzo di formaggio 5", seller: "Retailer 1", price: 10, weight: 1),
    CheesePiece(id: 6, name: "Pezzo di Formaggio 2", description: "Descrizione pezzo di formaggio 6", seller: "Retailer 2", price: 15, weight: 2),
    CheesePiece(id: 5, name: "Pezzo di Formaggio 1", description: "Descrizione pezzo di formaggio 5", seller: "Retailer 1", price: 10, weight: 1),
    CheesePiece(id: 6, name: "Pezzo di Formaggio 2", description: "Descrizione pezzo di formaggio 6", seller: "Retailer 2", price: 15, weight: 2),*/

  ];
  
  // Indice della pagina corrente
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    
    if (user == null) {
    // Se user non è ancora stato inizializzato, visualizza un indicatore di caricamento o un altro widget di fallback
      return CustomLoadingIndicator(progress: 4.5);
  } else {
    return Scaffold(
      appBar: _buildAppBar(),
      /*body: Stack(
        children: [
            Padding(
              padding: EdgeInsets.all(50.5),
              child: SingleChildScrollView(
                child:  
                  CustomProductList(products: products, onProductTap: handleProductTap),
                ),
              ),
              _buildDrawer(),
          ],
        ), */
      );
    }

  }


    /**
   * Construisce la NavBar Custom
   * - Inserimento del Logo 
   * - Inserimento del Testo 
   * - Inserimento del Menù 
   */
  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      leading: Image.asset('../assets/favicon.png'),
      centerTitle: true,
      title: 'Filiera-Token-Product-Buyed',
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      actions: [
        AnimatedBuilder(
          animation: _drawerSlideController,
          builder: (context, child) {
            return IconButton(
              onPressed: _toggleDrawer,
              icon: _isDrawerOpen() || _isDrawerOpening()
                  ? const Icon(
                      Icons.clear,
                      color: Colors.black,
                    )
                  : const Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
            );
          },
        ),
      ],
    );
  }

  
  Widget _buildDrawer() {
    return AnimatedBuilder(
      animation: _drawerSlideController,
      builder: (context, child) {
        return FractionalTranslation(
          translation: Offset(1.0 - _drawerSlideController.value, 0.0),
          child: _isDrawerClosed() ? const SizedBox() :  CustomMenuUserProductBuyed(userData: user! ,),
        );
      },
    );
  }

  void handleProductTap(BuildContext context, Product product) {
    // Fai qualcosa in base alla pagina in cui ti trovi
    print("Prodotto ${product.name} cliccato!");
    // Esegui azioni diverse in base alla pagina

    DialogProductDetails.show(
      context, 
      product,
      DialogType.DialogConversion,
      );
  }



}