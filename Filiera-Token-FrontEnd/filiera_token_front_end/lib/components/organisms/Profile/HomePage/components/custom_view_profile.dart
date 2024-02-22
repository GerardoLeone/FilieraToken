import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';


class CustomViewProfile extends StatefulWidget {

  const CustomViewProfile({super.key});


  @override
  _CustomViewProfile createState() => _CustomViewProfile();

}

class _CustomViewProfile extends State<CustomViewProfile> {
  
  /**
   * Function to Add Image 
   */
  Image? _image = Image.asset('../assets/man.png');

  Future<void> _pickImage() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    setState(() {
       _image = Image.network(image.path);
    });
    }
  }


  // Riga 1: Image, Wallet , Saldo
  Widget _buildFirstRow(){
    return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: () => _pickImage(),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 100.0,
                      backgroundImage: _image?.image,
                      backgroundColor: Colors.blue[200],
                    ),
                  ],
                ),
              ),

              SizedBox(width: 20,height: 20),
                Expanded(
                  child: 
                  Text(
                    "Wallet : "+utente.address,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
                const SizedBox(width: 3.0),
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
            );
  }

  // Riga 2: Email
  Widget _buildSecondRow(){
    // Riga 2: Email
    return Row(
              children: [
                Expanded(
                  child: Text(
                    "E-Mail : "+ utente.email,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            );
  }

  Widget _buildThirdRow(){
    return // Riga 3: Nome, cognome e password
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
                    obscureText: false,
                    decoration: const InputDecoration(
                      labelText: "Password",
                    ),
                    controller: TextEditingController(text: utente.password),
                  ),
                ),
              ],
            );
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
            _buildFirstRow(),         
            const SizedBox(height: 16.0),
            _buildSecondRow(),
            const SizedBox(height: 16.0),
            _buildThirdRow()
          ],
          ),
          );
  }





  @override
  Widget build(BuildContext context) {
      return Column(
      children: [
        // Other content widgets
        _buildViewProfile(),
         // Add the registration form
      ],
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