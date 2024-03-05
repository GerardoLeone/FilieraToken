// Molecules File 

import 'package:filiera_token_front_end/components/molecules/custom_nav_bar.dart';
import 'package:filiera_token_front_end/components/organisms/home_page/components/custom_menu_home_page.dart';
import 'package:filiera_token_front_end/components/organisms/home_page/components/slide_card.dart';


import 'package:flutter/material.dart';





class MyHomePage extends StatefulWidget {
  
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _HomePageAnimations();

}


class _HomePageAnimations extends State<MyHomePage> with SingleTickerProviderStateMixin {



  static String firstRowDescription = "Benvenuti nel mondo del latte fresco,dove la natura incontra la perfezione.\nImmagina un paesaggio idilliaco, circondato da lussureggianti pascoli e dolci colline,\n dove mucche felici pascolano serenamente sotto un cielo azzurro.\n È qui che inizia il viaggio di ogni goccia di latte che arriva sulle tue labbra";

  static String SecondRowDescription = "Benvenuti nel mondo del latte fresco,dove la natura incontra la perfezione.\nImmagina un paesaggio idilliaco, circondato da lussureggianti pascoli e dolci colline,\n dove mucche felici pascolano serenamente sotto un cielo azzurro.\n È qui che inizia il viaggio di ogni goccia di latte che arriva sulle tue labbra";
  
  static String thirdRowDescription = "Benvenuti nel mondo del latte fresco,dove la natura incontra la perfezione.\nImmagina un paesaggio idilliaco, circondato da lussureggianti pascoli e dolci colline,\n dove mucche felici pascolano serenamente sotto un cielo azzurro.\n È qui che inizia il viaggio di ogni goccia di latte che arriva sulle tue labbra";

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
  return MaterialApp(
    title: 'FilieraToken-Shop',
    home: Scaffold(
      // AppBar comune a tutti 
      appBar: _buildAppBar(),
      
      body: Stack(
        children: [
          _buildHomePage(),
          _buildDrawer(),
        ],
      ),
    ),
  );
}





  Widget _buildHomePage(){
    return ListView(
    padding: EdgeInsets.all(16.0),
    children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            '../assets/milk.png',
            width: MediaQuery.of(context).size.width * 0.2,
          ),
          SizedBox(width: 16.0),
          SlideInCard(
            title: 'La Filiera del Latte',
            description: firstRowDescription,
            beginOffset: Offset(1.5, 0),
            endOffset: Offset.zero,
          ),
        ],
      ),
      SizedBox(height: 16.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SlideInCard(
            title: 'La Filiera del Latte',
            description: SecondRowDescription,
            beginOffset: Offset(-1.5, 0),
            endOffset: Offset.zero,
          ),
          SizedBox(width: 16.0),
          Image.asset(
            '../assets/cheese_block.png',
            width: MediaQuery.of(context).size.width * 0.2,
          ),
        ],
      ),
      SizedBox(height: 16.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            '../assets/cheese_piece.png',
            width: MediaQuery.of(context).size.width * 0.2,
          ),
          SizedBox(width: 16.0),
          SlideInCard(
            title: 'La Filiera del Latte',
            description: thirdRowDescription,
            beginOffset: Offset(1.5, 0),
            endOffset: Offset.zero,
          ),
        ],
      ),
    ],
  );
}




   /// Construisce la NavBar Custom
   /// - Inserimento del Logo 
   /// - Inserimento del Testo 
   /// - Inserimento del Menù 
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


