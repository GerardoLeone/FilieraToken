import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FilieraToken',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'FilieraTokenShop'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage( {required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Logo
            Image.asset(
              '../assets/favicon.png',
              width: 100,
              height: 100,
            ),

            // Form di iscrizione
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  // Nome
                  TextField(
                    decoration: InputDecoration(labelText: 'Nome'),
                  ),

                  // Cognome
                  TextField(
                    decoration: InputDecoration(labelText: 'Cognome'),
                  ),

                  // Email
                  TextField(
                    decoration: InputDecoration(labelText: 'Email'),
                  ),

                  // Password
                  TextField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),

                  // Conferma password
                  TextField(
                    decoration: InputDecoration(labelText: 'Conferma password'),
                    obscureText: true,
                  ),

                  // Wallet
                  TextField(
                    decoration: InputDecoration(labelText: 'Wallet'),
                  ),

                  // Pulsante di iscrizione
                ElevatedButton(
                    child: Text('Iscriviti'),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Collegamento a "Sign In"
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Hai già un account?'),
                ElevatedButton(
                  child: Text('Accedi'),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}