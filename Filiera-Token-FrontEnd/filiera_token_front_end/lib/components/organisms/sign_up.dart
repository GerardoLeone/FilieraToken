
// Package Utils

import 'package:filiera_token_front_end/components/molecules/custom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';





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
   Widget buildBackButton(BuildContext context) {
    return Row(
              mainAxisAlignment: MainAxisAlignment.start, // Align to the left
              children: [
                const SizedBox(height: 150, width: 20),
                ElevatedButton(
                  child: const Text('Back'),
                  onPressed: () => context.go('/'),
                ),
              ],
            );
  }


  /**
   * Build Form di Registrazione 
   */
  Widget buildFormRegistrazione(BuildContext context){
            // Form di iscrizione
           return  Padding(
              padding: const EdgeInsets.all(55.5),
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

                // Padding   
                const SizedBox(height: 20,width: 20),
                // Pulsante di iscrizione
                ElevatedButton(
                    child: const Text('Registrati'),
                    onPressed: () {},
                  ),
                ],
              ),
            );
  }



  /***
   * Build Registered Action 
   */
  Widget buildIsRegistered(BuildContext context){
      return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Hai già un account?'),
                SizedBox(width: 20,height: 0),
                ElevatedButton(
                  child: const Text('Accedi'),
                  onPressed: () {},
                ),
              ],
            );
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBar.buildSimpleNavBar(),
      
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            /// Login Form 
            buildFormRegistrazione(context),
            /// Go to  "Sign In"
            buildIsRegistered(context),
            /// Back Button 
            buildBackButton(context)
          ],
        ),
      ),
    );
  }
}