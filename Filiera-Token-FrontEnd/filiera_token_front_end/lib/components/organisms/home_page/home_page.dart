// Molecules File 

import 'package:filiera_token_front_end/components/molecules/custom_nav_bar.dart';
import 'package:filiera_token_front_end/components/organisms/home_page/components/custom_menu_home_page.dart';


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';




class MyHomePage extends StatefulWidget {
  
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _HomePageAnimations();

}


class _HomePageAnimations extends State<MyHomePage> with SingleTickerProviderStateMixin {


//------------------------------------------------------------------------ First Row ------------------------------------------------------------------------------------//


  

  late AnimationController _drawerSlideController;

  @override
  void initState() {
    super.initState();

    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
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



  /// La prima riga serve per testare la pagina di Registrazione e Login
  Widget buildFirstRow(BuildContext context){
    return Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centra la riga
            children: <Widget>[
                // Button -> per andare alla pagina di Registrazione 
                //TODO :Insert Custom Button
                
                const SizedBox(width: 20), // Spazio tra i bottoni
                //TODO :Insert Custom Button
                buildSignUpButton(context),
                // Button -> per andare alla pagina di Login
                buildSingInButton(context)
            ],
    );
  }

  Widget buildSignUpButton(BuildContext context){
    return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Arrotonda i bordi
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20), // Spazio interno
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Testo più grande e bold
                      ), 
                  onPressed: () => 
                    context.go('/signup'),
                  child: const Text('SignUp'),
                );
  }

  Widget buildSingInButton(BuildContext context){
    return ElevatedButton(
                  onPressed: () => context.go('/signin'),
                    style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Arrotonda i bordi
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20), // Spazio interno
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Testo più grande e bold
                  ),
                  child: const Text('SignIn'),
                );
  }

//--------------------------------------------------------------- Second Row -----------------------------------------------------------------------------//


  /// Questa seconda riga e le successive ci serviranno solo per testare le varie rotte che ho abilitato nel main 
  Widget buildSecondRow(BuildContext context){
      return 
      Row( // Second row for new buttons
            mainAxisAlignment: MainAxisAlignment.center, // Center horizontally
            children: [
                  // Add your new ElevatedButton widgets here,
                  // following the same format as the existing ones
                  buildHomePageUser(context)
                  ],
      );
  }

  Widget buildHomePageUser(BuildContext context){
    return ElevatedButton(
                  onPressed: () => context.go('/home-page-user'),
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Arrotonda i bordi
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20), // Spazio interno
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Testo più grande e bold
                    ),
                  child: const Text('Home-Page-User'),
                  );
  }



  @override
  Widget build(BuildContext context) {

    MaterialApp homePage = MaterialApp(
      title: 'FilieraToken-Shop',
      home: Scaffold(
        // AppBar comune a tutti 
        appBar: _buildAppBar(),
        body: Stack(
        children: [
                //buildFirstRow(context),
                const SizedBox(width: 20,height: 20), // Spazio tra i bottoni
                //buildSecondRow(context),
                _buildDrawer()
              ],
          ), 
          ),
      );
    return homePage;
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
          child: _isDrawerClosed() ? const SizedBox() : const CustomMenuHomePage(),
        );
      },
    );
  }




}