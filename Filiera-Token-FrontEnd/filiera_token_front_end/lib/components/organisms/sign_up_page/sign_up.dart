import 'package:filiera_token_front_end/components/molecules/custom_alert_dialog.dart';
import 'package:filiera_token_front_end/components/organisms/sign_up_page/components/custom_menu_singup.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



// Package Utils
import 'package:filiera_token_front_end/components/molecules/custom_nav_bar.dart';
import 'package:filiera_token_front_end/components/atoms/custom_dropdown.dart';

// UserService - Registration
import 'package:filiera_token_front_end/components/organisms/user_environment/services/user_service.dart';



class MySignUpPage extends StatefulWidget {

  const MySignUpPage({super.key,required this.title});

  final String title;

  @override
  State<MySignUpPage> createState() => _MySignUpPageAnimations();

}

class _MySignUpPageAnimations extends State<MySignUpPage> with SingleTickerProviderStateMixin{

  var dropdownItems = ["MilkHub","CheeseProducer", "Retailer", "Consumer"];
  
  late String selectedValueUserType;

  late String nameInput;
  late String cognomeInput;
  late String fullName;


  late String emailInput;
  late String passwordInput;
  late String confermaPasswordInput;
  late String walletInput;
  
  TextEditingController ?_nameController;
  TextEditingController ?_lastNameController;
  TextEditingController ? _emailController;
  TextEditingController ?_passwordController;
  TextEditingController ?_confirmPasswordController;
  TextEditingController ?_walletController;

  /// Injection of Service 
  final userService = UserSerivce();
  /// Injection of Static Widget 
  final customPopUpDialog = CustomPopUpDialog();

  late AnimationController _drawerSlideController;



  
  @override
  void initState() {
    _nameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
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
    _nameController?.dispose();
    _lastNameController?.dispose();
    _emailController?.dispose(); 
     _passwordController?.dispose();
    _confirmPasswordController?.dispose();
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
   * Build Form di Registrazione 
   */
  Widget buildFormRegistrazione(BuildContext context){
            // Form di iscrizione
           return  Padding(
              padding: const EdgeInsets.all(55.5),
              child: Column(
                children: <Widget>[
                  // Nome
                   TextField(
                    decoration: InputDecoration(labelText: 'Nome'),
                    controller: _nameController,
                  ),

                  // Cognome
                   TextField(
                    decoration: InputDecoration(labelText: 'Cognome'),
                    controller: _lastNameController,
                  ),

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

                  // Conferma password
                   TextField(
                    decoration: InputDecoration(labelText: 'Conferma password'),
                    obscureText: true,
                    controller: _confirmPasswordController,

                  ),

                  // Wallet
                   TextField(
                    decoration: InputDecoration(labelText: 'Wallet'),
                    controller: _walletController,
                  ),

                // Padding   
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
                const SizedBox(height: 5,width: 20),

                // Pulsante di iscrizione
                ElevatedButton(
                    child: const Text('Registrati'),
                    onPressed: ()  async  {
                        // Recupera i valori dai controller
                        nameInput = _nameController!.text;
                        cognomeInput = _lastNameController!.text;
                        emailInput = _emailController!.text;
                        passwordInput = _passwordController!.text;
                        confermaPasswordInput = _confirmPasswordController!.text;
                        walletInput = _walletController!.text;

                        fullName = nameInput+cognomeInput;
                        
                        if(await userService.registrationUser(emailInput,fullName,confermaPasswordInput,walletInput,selectedValueUserType)){
                          /// TRUE Registration
                          customPopUpDialog.showSuccessPopupRegistration(context);
                          
                        }else{

                          /// FALSE Registration
                          customPopUpDialog.showErrorPopupRegistration(context, "Registrazione Non Avvenuta!");
                        }
                    }
                  ),
                  const SizedBox(height: 20,width: 20),
                  buildIsRegistered(context),
                ],
              ),
            );
  }



  /***
   * Build Registered Action 
   */
  Widget buildIsRegistered(BuildContext context){
      return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Hai già un account?'),
                SizedBox(width: 20,height: 0),
                
                ElevatedButton(
                  child: const Text('Login'),

                  onPressed: () => context.go('/signin'),
                
                ),
              ],
            );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: _buildAppBar(),
      
      body: Stack(
          children: <Widget>[
            /// Registration Form 
            buildFormRegistrazione(context),
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
          child: _isDrawerClosed() ? const SizedBox() : const CustomMenuSignup(),
        );
      },
    );
  }









}