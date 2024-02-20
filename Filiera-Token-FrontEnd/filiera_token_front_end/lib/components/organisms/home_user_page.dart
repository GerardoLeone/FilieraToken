import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:filiera_token_front_end/components/molecules/custom_nav_bar.dart';




class HomePageUser extends StatefulWidget {
  const HomePageUser({Key? key}) : super(key: key);

  @override
  State<HomePageUser> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageUser> {
  
  
  
  // Lista di prodotti fittizia
  final List<Prodotto> prodotti = [
    Prodotto(id: 1, nome: "Prodotto 1", prezzo: 10.0),
    Prodotto(id: 2, nome: "Prodotto 2", prezzo: 15.0),
    Prodotto(id: 3, nome: "Prodotto 3", prezzo: 20.0),
    // ... altri prodotti
    Prodotto(id: 5, nome: "Prodotto 1", prezzo: 10.0),
    Prodotto(id: 6, nome: "Prodotto 2", prezzo: 15.0),
    Prodotto(id: 7, nome: "Prodotto 3", prezzo: 20.0),
  ];

  // Indice della pagina corrente
  int currentPage = 0;



  CustomAppBar buildNavBar(BuildContext context){
    return CustomAppBar(title: 'FilieraToken-Shop',
            leading: Image.asset('../assets/favicon.png'),
            actions: [
              // Button -> Profile 
                ElevatedButton(
                        child: const Text('Profile'),
                        /// TODO :Update Route Logic 
                        onPressed: () => context.go('/home-page-user/profile'),
                        ),
              SizedBox(width: 20),
              // Button -> Logout -> Home Page Filiera Token 
                ElevatedButton(
                        child: const Text('Logout'),
                        onPressed: () => context.go('/'),
                        )
            ],
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: buildNavBar(context),
      body: Center(
        child: Column(
          children: [
            // Griglia di prodotti
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.5,
              ),
              itemCount: prodotti.length,
              itemBuilder: (context, index) {
                return _buildProdottoCard(prodotti[index]);
              },
            ),

            // Pulsanti per scorrere le pagine
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    if (currentPage > 0) {
                      setState(() {
                        currentPage--;
                      });
                    }
                  },
                  child: const Text("Precedente"),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    if (currentPage < prodotti.length / 9 - 1) {
                      setState(() {
                        currentPage++;
                      });
                    }
                  },
                  child: const Text("Successivo"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProdottoCard(Prodotto prodotto) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(prodotto.nome),
            Text("€${prodotto.prezzo}"),
          ],
        ),
      ),
    );
  }
}

class Prodotto {
  final int id;
  final String nome;
  final double prezzo;

  const Prodotto({
    required this.id,
    required this.nome,
    required this.prezzo,
  });
}
