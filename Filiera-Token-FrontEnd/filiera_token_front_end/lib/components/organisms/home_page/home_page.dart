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
                //_buildHomePageUser(context),
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