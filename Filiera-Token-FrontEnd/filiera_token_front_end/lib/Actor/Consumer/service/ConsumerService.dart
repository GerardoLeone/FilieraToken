

import 'dart:convert';

import 'dart:async' show Future;
import 'dart:ffi';
import 'package:filiera_token_front_end/models/User.dart';
import 'package:http/http.dart' as http;



class ConsumerService {


  static const String _apiUrl = 'http://127.0.0.1:5000/api/v1';

  static const String _APINameConsumer = "ConsumerService";

  static const String queryLogin = 'login';



    Future<bool> registerConsumer(String email, String fullName, String password, String walletConsumer) async {
    
    const url = '$_apiUrl/namespaces/default/apis/$_APINameConsumer/invoke/registerMilkHub';
    final headers = _getHeaders();
    final body = _getRegisterUserBody(email, fullName, password, walletConsumer);

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    // Controllo del codice di stato
    if (response.statusCode == 200 || response.statusCode == 202) {
      // Richiesta avvenuta con successo
      print('Registrazione avvenuta con successo');
      return true;
    } else {
      // Errore nella richiesta
      print('Registrazione Non avvenuta!');
      return false;
    }
  }

    Future<bool> loginConsumer(String email, String password, String wallet) async {
    const url = '$_apiUrl/namespaces/default/apis/$_APINameConsumer/invoke/$queryLogin';
    final headers = _getHeaders();
    final body = _getLoginPayload(email, password, wallet);
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    // Controllo del codice di stato
    if (response.statusCode == 200 || response.statusCode == 202) {
      // Richiesta avvenuta con successo
      print('Login avvenuto con successo');
      return true;
    } else {
      // Errore nella richiesta
      final error = jsonDecode(response.body)['error'];
      print('Login Non avvenuta!');
      return false;
    }
  }

    /**
     * Recupera l'id del Consumer 
     */
    Future<int> getConsumerId(String walletConsumer)async{
      return 0;
    }


    /**
     * Recupera i dati del Consumer 
     */
    Future<User?> getConsumerData(String walletConsumer,String idConsumer)async {
      return null;
    }




    Map<String, dynamic> _getLoginPayload(String email, String password, String wallet) {
    return {
      "input": {
        "email": email,
        "password": password,
        "walletConsumer": wallet,
      }
    };
  }
    
    Map<String, dynamic> _getRegisterUserBody(String email, String fullName, String password, String walletMilkHub) {
      return {
        'input': {
          'email': email,
          'fullName': fullName,
          'password': password,
          'walletConsumer': walletMilkHub,
        },
      };
    }

    Map<String, String> _getHeaders() {
  return {
    'Accept': 'application/json',
    'Request-Timeout': '2m0s',
    'Content-Type': 'application/json',
  };
}

}