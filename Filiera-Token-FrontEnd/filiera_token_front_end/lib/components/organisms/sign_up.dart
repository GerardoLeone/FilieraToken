
// Package Utils
import 'package:filiera_token_front_end/components/molecules/custom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:filiera_token_front_end/components/atoms/custom_button.dart';




class MySignUpPage extends StatefulWidget {

  const MySignUpPage(
     {
      super.key,
      required this.title
      }
  );

  final String title;

  @override
  _MySignUpPage createState() => _MySignUpPage();

}

class _MySignUpPage extends State<MySignUpPage> {




  /**
   * Build Back Button
   */
   Widget buildBackButton() {
    return ElevatedButton(
      child: const Text('Back'),
      onPressed: () => context.go('/'),
    );
  }


    /**
     * Construct my App Bar -> Nav Bar
     */
    CustomAppBar buildCustomAppBar(){
      return CustomAppBar(
            title: 'FilieraToken-Shop',
            leading: Image.asset('../assets/favicon.png'),
      );
    }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Form di iscrizione
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  // Nome
                  const TextField(
                    decoration: InputDecoration(labelText: 'Nome'),
                  ),

                  // Cognome
                  const TextField(
                    decoration: InputDecoration(labelText: 'Cognome'),
                  ),

                  // Email
                  const TextField(
                    decoration: InputDecoration(labelText: 'Email'),
                  ),

                  // Password
                  const TextField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),

                  // Conferma password
                  const TextField(
                    decoration: InputDecoration(labelText: 'Conferma password'),
                    obscureText: true,
                  ),

                  // Wallet
                  const TextField(
                    decoration: InputDecoration(labelText: 'Wallet'),
                  ),

                  // Pulsante di iscrizione
                ElevatedButton(
                    child: const Text('Iscriviti'),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Collegamento a "Sign In"
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                const Text('Hai già un account?'),
                
                ElevatedButton(
                  child: const Text('Accedi'),
                  onPressed: () {},
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start, // Align to the left
              children: [
                buildBackButton(),
                // ... existing widgets
              ],
            )
          ],
        ),
      ),
    );
  }
}