
import 'package:filiera_token_front_end/components/molecules/custom_loading_bar.dart';
import 'package:filiera_token_front_end/components/molecules/custom_product_list.dart';
import 'package:filiera_token_front_end/components/molecules/dialog/dialog_product_details.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/components/custom_menu_home_user_page_environment.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/services/secure_storage_service.dart';
import 'package:filiera_token_front_end/models/Product.dart';
import 'package:filiera_token_front_end/models/User.dart';
import 'package:filiera_token_front_end/utils/enums.dart';
import 'package:flutter/material.dart';

import 'package:filiera_token_front_end/components/molecules/custom_nav_bar.dart';
import 'package:get_it/get_it.dart';

class HomePageUser extends StatefulWidget {
  const HomePageUser({
    Key? key,
    required String userType,
    required String idUser, 
    }) : super(key: key);

  @override
  State<HomePageUser> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageUser> with SingleTickerProviderStateMixin {

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
        productList = ConsumerBuyerInventoryService.getCheesePieceList(wallet);
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
            child: FutureBuilder(
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
                    child: CustomProductList(products: products, onProductTap: handleProductTap),
                  );
                }
              },
            ),
          ),
          _buildDrawer(),
        ],
      ),
    );
  }
  }

  void handleProductTap(BuildContext context, Product product) {
    // Fai qualcosa in base alla pagina in cui ti trovi
    print("Prodotto ${product.name} cliccato!");
    // Esegui azioni diverse in base alla pagina
    DialogProductDetails.show(
      context, 
      product,
      DialogType.DialogPurchase);
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
      title: 'Filiera-Token-Shop',
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
          child: _isDrawerClosed() ? const SizedBox() :  CustomMenuHomeUserPageEnv(userData: user!),
        );
      },
    );
  }





}