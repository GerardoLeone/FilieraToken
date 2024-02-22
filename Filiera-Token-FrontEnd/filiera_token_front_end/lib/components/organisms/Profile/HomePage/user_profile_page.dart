import 'package:flutter/material.dart';

import 'package:filiera_token_front_end/components/organisms/Profile/HomePage/components/custom_menu_profile.dart';
import 'package:filiera_token_front_end/components/organisms/Profile/HomePage/components/custom_view_profile.dart';
import 'package:filiera_token_front_end/components/molecules/custom_nav_bar.dart';


class UserProfilePage extends StatefulWidget {

  const UserProfilePage({
    super.key,
  });

  @override
  State<UserProfilePage> createState() =>
      _UserProfilePageAnimations();
}

class _UserProfilePageAnimations extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {


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


  /**
   * Costruisci un Floating Button Action per l'eliminazione dell'account 
   */
  Positioned _buildDeleteAccountButton(){

    return Positioned(
        bottom: 16.0,
        right: 16.0,
        child: FloatingActionButton(
      onPressed: () {
        // Mostra un dialogo di conferma per l'eliminazione dell'account
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Elimina account"),
            content: const Text("Sei sicuro di voler eliminare il tuo account?"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Annulla"),
              ),
              TextButton(
                onPressed: () {
                  // Elimina l'account
                  // ...
                  Navigator.pop(context);
                },
                child: const Text("Elimina"),
              ),
            ],
          ),
        );
      },
      backgroundColor: Colors.red,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: const Icon(Icons.delete),
    ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          CustomViewProfile(),
          _buildDeleteAccountButton(),
          _buildDrawer(),
        ],
      ),
    );
  }


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
          child: _isDrawerClosed() ? const SizedBox() : const CustomMenu(),
        );
      },
    );
  }



}





