import 'package:filiera_token_front_end/Actor/CheeseProducer/service/CheeseProducerInventoryService.dart';
import 'package:filiera_token_front_end/Actor/Consumer/service/ConsumerBuyerService.dart';
import 'package:filiera_token_front_end/Actor/MilkHub/service/MilkHubInventoryService.dart';
import 'package:filiera_token_front_end/Actor/Retailer/service/RetailerInventoryService.dart';
import 'package:filiera_token_front_end/components/molecules/custom_loading_bar.dart';
import 'package:filiera_token_front_end/components/molecules/custom_nav_bar.dart';
import 'package:filiera_token_front_end/components/molecules/custom_product_list.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/inventory_profile/components/custom_menu_user_inventory.dart';
import 'package:filiera_token_front_end/components/molecules/dialog/dialog_product_details.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/services/secure_storage_service.dart';
import 'package:filiera_token_front_end/models/Product.dart';
import 'package:filiera_token_front_end/models/User.dart';
import 'package:filiera_token_front_end/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

//Prodotti convertiti
class UserProfileInventoryProductPage extends StatefulWidget {
  const UserProfileInventoryProductPage({Key? key, 
  required String userType,
   required String idUser
   }) : super(key: key);

  @override
  State<UserProfileInventoryProductPage> createState() => _UserProfileInventoryProductPageState();
  
}

class _UserProfileInventoryProductPageState extends State<UserProfileInventoryProductPage> with SingleTickerProviderStateMixin{

  late AnimationController _drawerSlideController;

  late SecureStorageService secureStorageService;

  ConsumerBuyerService consumerBuyerService = ConsumerBuyerService();

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
  
  // Indice della pagina corrente
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    // Ottieni l'istanza di UserProvider
    if (user == null) {
    // Se user non è ancora stato inizializzato, visualizza un indicatore di caricamento o un altro widget di fallback
      return CustomLoadingIndicator(progress: 4.5);
      } else {

      print("Build!");
      Actor actor = user!.type; //TODO: gettarsi con hive il valore dell'attore    
      String wallet = user!.wallet; //TODO: gettarsi con hive il wallet
      Future<List<Product>> productList = Future.value([]);

      print(actor);
      print(wallet);

      switch(actor) {
        case Actor.MilkHub:
          productList = MilkHubInventoryService.getMilkBatchList(wallet);
          break;
        case Actor.CheeseProducer:
          productList = CheeseProducerInventoryService.getCheeseBlockList(wallet);
          break;
        case Actor.Retailer:
          productList = RetailerInventoryService.getCheesePieceList(wallet);
          break;
        case Actor.Consumer:
          productList = consumerBuyerService.getCheesePieceList(wallet);
          break;  
        default:
          print("Errore nella selezione dell'attore in fase di build (home_user_page.dart)");
          break;
      }

      return Scaffold(
        appBar: _buildAppBar(),
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(50.5),
                child: CustomProductList(productList: productList, onProductTap: handleProductTap),
              ),
              _buildDrawer(),
            ],
          ),
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
      title: 'Filiera-Token-Inventory',
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
          child: _isDrawerClosed() ? const SizedBox() :  CustomMenuUserInventory(userData: user!,),
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
      DialogType.DialogConversion);
  }



}