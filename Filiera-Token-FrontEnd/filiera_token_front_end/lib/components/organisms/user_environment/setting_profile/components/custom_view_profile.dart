import 'package:filiera_token_front_end/components/organisms/user_environment/services/secure_storage_service.dart';
import 'package:filiera_token_front_end/models/User.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:image_picker/image_picker.dart';


class CustomViewProfile extends StatefulWidget {

  final User userData;
  CustomViewProfile({super.key, required this.userData});
  


  @override
  _CustomViewProfile createState() => _CustomViewProfile();

}

class _CustomViewProfile extends State<CustomViewProfile> {


  @override
  void initState()  {
    super.initState();
  }

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


  //TODO : Remoxe Text with InputValidator 

  // Riga 1: Image, Wallet , Saldo
  Widget _buildFirstRow(User userDataStore){


    String id = userDataStore.id;
    String fullName = userDataStore.fullName;
    String balance = userDataStore.balance;
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

              SizedBox(width: 20, height: 20),
                Expanded(
                  child: 
                  Text(
                    "Wallet : "+id,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
                const SizedBox(width: 3.0),
                Text(
                  "Saldo: " + balance + " FTL",
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
  Widget _buildSecondRow(User userDataStored){
    String password = userDataStored.password;
    String email = userDataStored.email;
    // Riga 2: Email
    return Row(
              children: [
                Expanded(
                  child: Text(
                    "E-Mail : "+ email,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            );
  }

  Widget _buildThirdRow(User userDataStored){
    String password = userDataStored.password;
    return // Riga 3: Nome, cognome e password
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.toString(),
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
                    controller: TextEditingController(text: password),
                  ),
                ),
              ],
            );
  }
  
  

    /**
   * Build Form di Registrazione 
   */

  Widget _buildViewProfile(User userDataStored)  {
           return 
           Padding(
          padding: const EdgeInsets.all(120.0),
            child: Column(
                  children: [
            _buildFirstRow(userDataStored),         
            const SizedBox(height: 16.0),
            _buildSecondRow(userDataStored),
            const SizedBox(height: 16.0),
            _buildThirdRow(userDataStored)
          ],
        ),
      );
  }





  @override
  Widget build(BuildContext context) {

      return Column(
      children: [
        // Other content widgets
        _buildViewProfile(widget.userData),
         // Add the registration form
      ],
    );
  }

}
