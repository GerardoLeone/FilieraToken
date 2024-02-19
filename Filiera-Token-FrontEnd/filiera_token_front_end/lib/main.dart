import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Page 
import 'package:filiera_token_front_end/components/organisms/sign_in.dart';
import 'package:filiera_token_front_end/components/organisms/sign_up.dart';
import 'package:filiera_token_front_end/components/organisms/home_page.dart';


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
  ],
);




