import 'package:flutter/material.dart';

import 'package:filiera_token_front_end/components/molecules/custom_menu_profile.dart';

class UserProfilePage extends StatefulWidget {

  const UserProfilePage({
    super.key,
  });

  @override
  State<UserProfilePage> createState() =>
      _UserProfilePageAnimations();
}

class _UserProfilePageAnimations extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _drawerSlideController;

  @override
  void initState() {
    super.initState();

    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _drawerSlideController.dispose();
    super.dispose();
  }

  bool _isDrawerOpen() {
    return _drawerSlideController.value == 1.0;
  }

  bool _isDrawerOpening() {
    return _drawerSlideController.status == AnimationStatus.forward;
  }

  bool _isDrawerClosed() {
    return _drawerSlideController.value == 0.0;
  }

  void _toggleDrawer() {
    if (_isDrawerOpen() || _isDrawerOpening()) {
      _drawerSlideController.reverse();
    } else {
      _drawerSlideController.forward();
    }
  }


  /**
   * Build Form di Registrazione 
   */
  Widget _buildViewProfile(){
           return 
           Padding(
          padding: const EdgeInsets.all(120.0),
            child: Column(
                  children: [

                     Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50.0, // Modifica la dimensione dell'immagine se serve
              backgroundImage: const NetworkImage("../assets/man.png"), // Sostituisci "utente.immagineProfilo" con la tua fonte dell'immagine
            ),
          ],
        ),
        // Spazio tra le righe
        const SizedBox(height: 16.0),
            // Riga 2: Indirizzo e saldo
            Row(
              children: [
                Expanded(
                  child: 
                  Text(
                    utente.address,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
                const SizedBox(width: 16.0),
                Text(
                  "Saldo: \$" + utente.balance.toStringAsFixed(2),
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implementare la ricarica del conto
                  },
                  child: const Text("Ricarica"),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // Riga 3: Email
            Row(
              children: [
                Expanded(
                  child: Text(
                    utente.email,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // Riga 4: Nome, cognome e password
            Row(
              children: [
                Expanded(
                  child: Text(
                    utente.nome + " " + utente.cognome,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                    ),
                    controller: TextEditingController(text: utente.password),
                  ),
                ),
              ],
            ),
          ],),);
  }

  /**
   * Costruisci un Floating Button Action per l'eliminazione dell'account 
   */
  Positioned _buildDeleteAccountButton(){

    return Positioned(
        bottom: 16.0,
        right: 16.0,
        child: FloatingActionButton(
      onPressed: () {
        // Mostra un dialogo di conferma per l'eliminazione dell'account
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Elimina account"),
            content: const Text("Sei sicuro di voler eliminare il tuo account?"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Annulla"),
              ),
              TextButton(
                onPressed: () {
                  // Elimina l'account
                  // ...
                  Navigator.pop(context);
                },
                child: const Text("Elimina"),
              ),
            ],
          ),
        );
      },
      backgroundColor: Colors.red,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: const Icon(Icons.delete),
    ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildContent(),
          _buildDeleteAccountButton(),
          _buildDrawer(),
        ],
      ),
    );
  }


  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: Image.asset('../assets/favicon.png'),
      centerTitle: true,
      title: const Text(
        'Filiera-Token-Shop',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      actions: [
        AnimatedBuilder(
          animation: _drawerSlideController,
          builder: (context, child) {
            return IconButton(
              onPressed: _toggleDrawer,
              icon: _isDrawerOpen() || _isDrawerOpening()
                  ? const Icon(
                      Icons.clear,
                      color: Colors.black,
                    )
                  : const Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Other content widgets
        _buildViewProfile(),
         // Add the registration form
      ],
    );
  }

  Widget _buildDrawer() {
    return AnimatedBuilder(
      animation: _drawerSlideController,
      builder: (context, child) {
        return FractionalTranslation(
          translation: Offset(1.0 - _drawerSlideController.value, 0.0),
          child: _isDrawerClosed() ? const SizedBox() : const CustomMenu(),
        );
      },
    );
  }
}



class Utente {
  final String address;
  final double balance;
  final String email;
  final String nome;
  final String cognome;
  final String password;

  const Utente({
    required this.address,
    required this.balance,
    required this.email,
    required this.nome,
    required this.cognome,
    required this.password,
  });
}

final utente = Utente(
  address: "asdfjhafsdfbsjdhfbh39548454875",
  balance: 100.0,
  email: "email@utente.it",
  nome: "Nome",
  cognome: "Cognome",
  password: "********",
);

