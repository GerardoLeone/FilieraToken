import 'package:filiera_token_front_end/components/organisms/user_environment/history_profile/user_profile_history.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/home_user_page.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/inventory_profile/user_profile_inventory.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/product_buy_profile/user_profile_product_buyed.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/setting_profile/setting_user_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Page 
import 'package:filiera_token_front_end/components/organisms/sign_in_page/sign_in.dart';
import 'package:filiera_token_front_end/components/organisms/sign_up_page/sign_up.dart';
import 'package:filiera_token_front_end/components/organisms/home_page/home_page.dart';

// Page User 


// Profile Page 
//import 'package:filiera_token_front_end/components/organisms/user_environment/setting_profile/setting_user_profile_page.dart';

// Profile Sub-Page
//import 'package:filiera_token_front_end/components/organisms/user_environment/history_profile/user_profile_history.dart';
//import 'package:filiera_token_front_end/components/organisms/user_environment/inventory_profile/user_profile_inventory.dart';

void main() { 
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  /// Constructs a [MyApp]
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

/**
 * Map Router 
 */
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    
    GoRoute(
      path: '/',
      builder: (context, state) => const MyHomePage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const MySignUpPage(title: "Filiera-Token-SignUp"),
    ),
    GoRoute(
      path: '/signin',
      builder: (context, state) => const MySignInPage(title: "Filiera-Token-SignIn"),
    ),

    GoRoute(
    path: '/home-page-user',
    builder: (context, state) => const HomePageUser(),
    routes: [
      GoRoute(
        path: 'profile',
        builder: (context, state) => const UserProfilePage(),
        routes: [
            /// Sub Path of Profile of User
            GoRoute(
              path: 'history',
              builder: (context,state)=> const UserProfileHistoryPage()), 
            GoRoute(
              path: 'inventory',
              builder: (context,state) => const UserProfileInventoryProductPage()),                
            GoRoute(
              path: 'product-buyed',
              builder: ((context, state) => const UserProfileProductBuyed())),
        ]
      ),
    ],
  ),
  ],
);




