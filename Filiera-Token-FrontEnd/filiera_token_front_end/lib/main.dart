import 'package:flutter/material.dart';
import './sign_in.dart';
import './sign_up.dart';
import 'package:flutter_router/flutter_router.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FilieraToken-Shop',
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('FilieraToken-Shop')), // Centra la scritta
          leading: Image.asset('../assets/favicon.png'),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centra la riga
            children: <Widget>[
                // Button -> per andare alla pagina di Registrazione 
                ElevatedButton(
                  onPressed: () {
                    // Vai alla pagina di Registrazione
                  },
                  child: Text('SignUp'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Arrotonda i bordi
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20), // Spazio interno
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Testo più grande e bold
                  ),
                ),
              SizedBox(width: 20), // Spazio tra i bottoni
              // Button -> per andare alla pagina di Login
              ElevatedButton(
                onPressed: () {
                  // Vai alla pagina di Login
                },
                child: Text('SignIn'),
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Arrotonda i bordi
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20), // Spazio interno
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Testo più grande e bold
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
