import 'package:flutter/material.dart';

// Components Page 
import 'package:filiera_token_front_end/components/organisms/user_environment/setting_profile/components/custom_floating_button_delete.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/setting_profile/components/custom_menu_profile.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/setting_profile/components/custom_view_profile.dart';
import 'package:filiera_token_front_end/components/molecules/custom_nav_bar.dart';


class UserProfilePage extends StatefulWidget {

  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageAnimations();
}


class _UserProfilePageAnimations extends State<UserProfilePage> with SingleTickerProviderStateMixin {

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          const CustomViewProfile(),
          const CustomDeleteUserButton(),
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
      title: 'Filiera-Token-Setting',
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





