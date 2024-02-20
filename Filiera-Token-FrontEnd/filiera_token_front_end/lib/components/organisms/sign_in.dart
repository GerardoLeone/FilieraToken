import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../molecules/custom_nav_bar.dart';

class MySignInPage extends StatefulWidget {
  const MySignInPage({super.key, required this.title});

  final String title;

  @override
  _MySignInPage createState() => _MySignInPage();
}

class _MySignInPage extends State<MySignInPage> {



/**
   * Build Back Button
   */
   Widget buildBackButton(BuildContext context) {
    return Row(
              mainAxisAlignment: MainAxisAlignment.start, // Align to the left
              children: [
                SizedBox(width: 30,),
                ElevatedButton(
                        child: const Text('Back'),
                        onPressed: () => context.go('/'),
                        )
              ],
            );
  }


  /**
   * Build Login Form 
   */

  Widget buildFormLogin(BuildContext context){
    
    return Padding(

              padding: const EdgeInsets.all(120.0),
              child: Column(
                children: <Widget>[
                  /// TODO : Insert Custom Button 
                  // Email
                  const TextField(
                    decoration: InputDecoration(labelText: 'Email'),
                  ),

                  // Password
                  const TextField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),

                  // Wallet
                  const TextField(
                    decoration: InputDecoration(labelText: 'Wallet'),
                  ),

                /// Spazio tra i vari field e il Button   
                const SizedBox(height: 20,width: 20),
                // Pulsante di iscrizione
                ElevatedButton(
                    child: const Text('Login'),
                    onPressed: () {},
                  ),
                ],
              ),
            );
  }



  /**
   * Build Layout 
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Nav Bar 
      appBar: CustomAppBar.buildSimpleNavBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Form di iscrizione
            buildFormLogin(context),
            /// Back Button 
            buildBackButton(context)
          ],
        ),
      ),
    );
  }
}