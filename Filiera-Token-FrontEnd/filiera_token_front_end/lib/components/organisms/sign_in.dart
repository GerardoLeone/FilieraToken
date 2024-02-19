import 'package:flutter/material.dart';

class MySignInPage extends StatefulWidget {
  const MySignInPage({super.key, required this.title});

  final String title;

  @override
  _MySignInPage createState() => _MySignInPage();
}

class _MySignInPage extends State<MySignInPage> {
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
          ],
        ),
      ),
    );
  }
}