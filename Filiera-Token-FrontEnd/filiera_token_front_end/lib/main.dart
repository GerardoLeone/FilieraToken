import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Page 
import 'package:filiera_token_front_end/components/organisms/sign_in.dart';
import 'package:filiera_token_front_end/components/organisms/sign_up.dart';
import 'package:filiera_token_front_end/components/organisms/home_page.dart';

// Page User 
import 'package:filiera_token_front_end/components/organisms/User-Profile/home_user_page.dart';


// Profile Page 
import 'package:filiera_token_front_end/components/organisms/User-Profile/SettingProfile/user_profile_page.dart';

// Profile Sub-Page
import 'package:filiera_token_front_end/components/organisms/User-Profile/HistoryProfile/user_profile_history.dart';
import 'package:filiera_token_front_end/components/organisms/User-Profile/InventoryProfile/user_profile_inventory.dart';

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
              builder: (context,state) => const UserProfileInventoryProductPage())                
        ]
      ),
    ],
  ),
  ],
);




