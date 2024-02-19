import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';




class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {

    
    MaterialApp homePage = MaterialApp(
      title: 'FilieraToken-Shop',
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('FilieraToken-Shop')), // Centra la scritta
          leading: Image.asset('../assets/favicon.png'),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centra la riga
            children: <Widget>[
                // Button -> per andare alla pagina di Registrazione 

                ElevatedButton(
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
                ),
              const SizedBox(width: 20), // Spazio tra i bottoni

              // Button -> per andare alla pagina di Login
              ElevatedButton(
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
                ),
            ],
          ),
        ),
      ), 
    );
    return homePage;
  }
}