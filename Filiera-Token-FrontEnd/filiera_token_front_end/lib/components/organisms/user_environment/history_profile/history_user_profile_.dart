import 'dart:async';

import 'package:filiera_token_front_end/components/molecules/custom_nav_bar.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/history_profile/components/custom_eventi_list.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/history_profile/components/custom_menu_history.dart';
import 'package:flutter/material.dart';

//Prodotti convertiti
class UserProfileHistoryPage extends StatefulWidget {
  const UserProfileHistoryPage({Key? key, required String idUser, required String userType}) : super(key: key);

  @override
  State<UserProfileHistoryPage> createState() => _UserProfileInventoryProductPageState();
  
}

class _UserProfileInventoryProductPageState extends State<UserProfileHistoryPage> with SingleTickerProviderStateMixin{

  late AnimationController _drawerSlideController;

  late Timer _timer;


final GlobalKey<EventListState> _eventListKey = GlobalKey<EventListState>();


  @override
  void initState() {
    super.initState();

    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      setState(() {
        _eventListKey.currentState?.generateAndAddEvent();
      });
    });
  }

  @override
  void dispose() {
    _drawerSlideController.dispose();
        _timer.cancel();
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
    return Scaffold(
          appBar: _buildAppBar(),
          body: Stack(
          children: [

            Padding(
              padding: EdgeInsets.all(50.5),
              child: 
                  /// EventList    
                  EventList(key: _eventListKey,)
            ),
          _buildDrawer(),
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
      title: 'Filiera-Token-Shop-History',
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
          child: _isDrawerClosed() ? const SizedBox() : const CustomMenuHistory(),
        );
      },
    );
  }




}

