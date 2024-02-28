import 'package:filiera_token_front_end/Actor/Consumer/service/ConsumerService.dart';
import 'package:filiera_token_front_end/components/atoms/custom_dropdown.dart';
import 'package:filiera_token_front_end/components/organisms/sign_in_page/components/custom_menu_singin.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../molecules/custom_nav_bar.dart';

import 'package:filiera_token_front_end/components/organisms/user_environment/services/user_service.dart';


class MySignInPage extends StatefulWidget {
  const MySignInPage({super.key, required this.title});

  final String title;

  @override
  State<MySignInPage> createState() => _MySignInPageAnimations();
}

class _MySignInPageAnimations extends State<MySignInPage> with SingleTickerProviderStateMixin{

  var dropdownItems = ["MilkHub","CheeseProducer", "Retailer", "Consumer"];
  
  late AnimationController _drawerSlideController;

  final ConsumerService _consumerService = ConsumerService();

  /// Select value to Menu 
  late String selectedValueUserType;

  /// Controller of Text 
  TextEditingController ? _emailController;
  TextEditingController ?_passwordController;
  TextEditingController ?_walletController;

  /// Dynamic Value to Retrieve 
  late String emailInput;
  late String passwordInput;
  late String walletInput;

/// Injection of Service 
  final userService = UserSerivce();

   @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _walletController = TextEditingController();
    selectedValueUserType = "MilkHub";
    
    super.initState();
    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }


   @override
  void dispose() {
    // Clean up the controllers when the Widget is disposed
    _emailController?.dispose(); 
     _passwordController?.dispose();
    _walletController?.dispose();
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



/**
   * Build Back Button
   */
   Widget _buildBackButton(BuildContext context) {
    return Row(
              mainAxisAlignment: MainAxisAlignment.start, // Align to the left
              children: [
                SizedBox(width: 30,),
                ElevatedButton(
                        child: const Text('Back'),
                        onPressed: () => context.go('/'),
                        )
              ],
            );
  }


  /**
   * Build Back Button
   */
   Widget _buildRegisterButton(BuildContext context) {
    return  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Non sei registrato ?'),
                SizedBox(width: 20,height: 0),
                
                ElevatedButton(
                  child: const Text('Registrati'),

                  onPressed: () => context.go('/signup'),
                
                ),
              ],
            );
  }


  /**
   * Build Login Form 
   */

  Widget _buildFormLogin(BuildContext context){
    
    return Padding(

              padding: const EdgeInsets.all(120.0),
              child: Column(
                children: <Widget>[
                  // Email
                   TextField(
                    decoration: InputDecoration(labelText: 'Email'),
                    controller: _emailController,
                  ),

                  // Password
                   TextField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: _passwordController,
                  ),

                  // Wallet
                   TextField(
                    decoration: InputDecoration(labelText: 'Wallet'),
                    controller: _walletController,
                  ),

                  const SizedBox(height: 20,width: 20),

                  // Select value of DropDown
                CustomDropdown<String>(
                    // Pass the item list
                    items: dropdownItems,

                    // Optionally set an initial value or use the first item as default
                    value: "MilkHub", // Adjust as needed

                    // Handle changes in the selection
                    onChanged: (value) {
                      setState(() {
                        // Update selected value here, possibly triggering additional actions
                        selectedValueUserType = value!;
                      });
                    },
                  ),

                /// Spazio tra i vari field e il Button   
                const SizedBox(height: 20,width: 20),
                // Pulsante di iscrizione
                ElevatedButton(
                    child: const Text('Login'),
                    onPressed: () async {
                      /// do Login ()
                      emailInput = _emailController!.text;
                      passwordInput = _passwordController!.text;
                      walletInput = _walletController!.text;
                      if(await userService.login(emailInput, passwordInput, walletInput, selectedValueUserType) ){
                        /// Go to Home User page 
                        /// Create a JWT (Optional)  
                        /// Move to home-page-user and select our product 
                        /// Retrieve all data of User 
                        /// Retrieve all data of other Product 
                        /// 
                      
                      }else{
                          /// Login Errata 
                      } 
                     
                    },
                  ),
                  const SizedBox(height: 20,width: 20),
                  /// Button to go to Register 
                  _buildRegisterButton(context),
                ],
              ),
            );
  }



  /**
   * Build Layout 
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Nav Bar 
      appBar: _buildAppBar(),
      body: Stack(
          children: <Widget>[
            // Form di iscrizione
            _buildFormLogin(context),
            _buildDrawer()
          ],
        ),
    );
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
          child: _isDrawerClosed() ? const SizedBox() : const CustomMenuSignin(),
        );
      },
    );
  }


}