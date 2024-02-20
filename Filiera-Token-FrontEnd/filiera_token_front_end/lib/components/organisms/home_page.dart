// Molecules File 

import 'package:filiera_token_front_end/components/molecules/custom_nav_bar.dart';


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';




class MyHomePage extends StatelessWidget {
  
  const MyHomePage({super.key});

//------------------------------------------------------------------------ First Row ------------------------------------------------------------------------------------//


  /// La prima riga serve per testare la pagina di Registrazione e Login
  buildFirstRow(BuildContext context){
    return Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centra la riga
            children: <Widget>[
                // Button -> per andare alla pagina di Registrazione 
                //TODO :Insert Custom Button
                
                const SizedBox(width: 20), // Spazio tra i bottoni
                //TODO :Insert Custom Button
                buildSignUpButton(context),
                // Button -> per andare alla pagina di Login
                buildSingInButton(context)
            ],
    );
  }

  Widget buildSignUpButton(BuildContext context){
    return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Arrotonda i bordi
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20), // Spazio interno
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Testo più grande e bold
                      ), 
                  onPressed: () => 
                    context.go('/signup'),
                  child: const Text('SignUp'),
                );
  }

  Widget buildSingInButton(BuildContext context){
    return ElevatedButton(
                  onPressed: () => context.go('/signin'),
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Arrotonda i bordi
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20), // Spazio interno
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Testo più grande e bold
                  ),
                child: const Text('SignIn'),
                );
  }

//--------------------------------------------------------------- Second Row -----------------------------------------------------------------------------//


  /// Questa seconda riga e le successive ci serviranno solo per testare le varie rotte che ho abilitato nel main 
  buildSecondRow(BuildContext context){
      return 
      Row( // Second row for new buttons
            mainAxisAlignment: MainAxisAlignment.center, // Center horizontally
            children: [
                  // Add your new ElevatedButton widgets here,
                  // following the same format as the existing ones
                  buildHomePageUser(context)
                  ],
      );
  }

  Widget buildHomePageUser(BuildContext context){
    return ElevatedButton(
                  onPressed: () => context.go('/home-page-user'),
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Arrotonda i bordi
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20), // Spazio interno
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Testo più grande e bold
                    ),
                  child: const Text('Home-Page-User'),
                  );
  }



  @override
  Widget build(BuildContext context) {

    
    MaterialApp homePage = MaterialApp(
      title: 'FilieraToken-Shop',
      home: Scaffold(
        // AppBar comune a tutti 
        appBar: CustomAppBar.buildSimpleNavBar(),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildFirstRow(context),
                const SizedBox(width: 20,height: 20), // Spazio tra i bottoni
                buildSecondRow(context),
              ],
          ), 
          ),
      ),
    );
    return homePage;
  }
}