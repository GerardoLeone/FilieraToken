import 'dart:async' show Future;
import 'package:http/http.dart' as http;
import 'dart:convert';


class UserSerivce {


  static const String _apiUrl = 'http://127.0.0.1:5000/api/v1';

  static const String _APINameMilkHub = "MilkHubService-API";

  static const String _APINameCheeseProducer = "CheeseProducer-API";

  static const String _APINameRetailer = "Retailer-API";

  static const String _APINameConsumer = "Consumer-API";

  static const String queryLogin = 'login';



  Future<bool> registrationUser(String email, String fullName, String password, String walletMilkHub, String typeUser) async {

    switch(typeUser){
      
      case "MilkHub":{
        return registerMilkHub(email, fullName, password, walletMilkHub);
      }
      case "CheeseProducer":{
        return registerCheeseProducer(email, fullName, password, walletMilkHub);
      }
      case "Retailer":{
        return registerRetailer(email, fullName, password, walletMilkHub);
      }
      case "Consumer":{
        return registerConsumer(email, fullName, password, walletMilkHub);
      }
      default:{
        return false;
      }
    }
  }




  Future<bool> registerMilkHub(String email, String fullName, String password, String walletMilkHub) async {
    
    const url = '$_apiUrl/namespaces/default/apis/$_APINameMilkHub/invoke/registerMilkHub';
    final headers = _getHeaders();
    final body = _getRegisterUserBody(email, fullName, password, walletMilkHub);

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
      final error = jsonDecode(response.body)['error'];
      print('Registrazione Non avvenuta!' + error);
      return false;
    }
  }


  Future<bool> registerCheeseProducer(String email, String fullName, String password, String walletMilkHub) async {
    
    const url = '$_apiUrl/namespaces/default/apis/$_APINameCheeseProducer/invoke/registerMilkHub';
    final headers = _getHeaders();
    final body = _getRegisterUserBody(email, fullName, password, walletMilkHub);

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
      final error = jsonDecode(response.body)['error'];
      print('Registrazione Non avvenuta!');
      return false;
    }
  }


  Future<bool> registerRetailer(String email, String fullName, String password, String walletMilkHub) async {
    
    const url = '$_apiUrl/namespaces/default/apis/$_APINameRetailer/invoke/registerMilkHub';
    final headers = _getHeaders();
    final body = _getRegisterUserBody(email, fullName, password, walletMilkHub);

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
      final error = jsonDecode(response.body)['error'];
      print('Registrazione Non avvenuta!');
      return false;
    }
  }


  Future<bool> registerConsumer(String email, String fullName, String password, String walletMilkHub) async {
    
    const url = '$_apiUrl/namespaces/default/apis/$_APINameConsumer/invoke/registerMilkHub';
    final headers = _getHeaders();
    final body = _getRegisterUserBody(email, fullName, password, walletMilkHub);

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




  Map<String, dynamic> _getRegisterUserBody(String email, String fullName, String password, String walletMilkHub) {
  return {
    'input': {
      'email': email,
      'fullName': fullName,
      'password': password,
      'walletMilkHub': walletMilkHub,
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





  Future<bool> login(String email, String password, String walletMilkHub, String typeUser) async {

    switch(typeUser){
      
      case "MilkHub":{
        return loginMilkHub(email, password, walletMilkHub);
      }
      case "CheeseProducer":{
        return loginCheeseProducer(email, password, walletMilkHub);
      }
      case "Retailer":{
        return loginRetailer(email, password, walletMilkHub);
      }
      case "Consumer":{
        return loginConsumer(email, password, walletMilkHub);
      }
      default:{
        return false;
      }
    }
  }



  Map<String, dynamic> _getLoginPayload(String email, String password, String wallet) {
    return {
      "input": {
        "email": email,
        "password": password,
        "walletMilkHub": wallet,
      }
    };
  }


  Future<bool> loginMilkHub(String email, String password, String wallet) async {
    const url = '$_apiUrl/namespaces/default/apis/$_APINameMilkHub/invoke/$queryLogin';
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


  Future<bool> loginCheeseProducer(String email, String password, String wallet) async {
    const url = '$_apiUrl/namespaces/default/apis/$_APINameCheeseProducer/invoke/$queryLogin';
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


  Future<bool> loginRetailer(String email, String password, String wallet) async {
    const url = '$_apiUrl/namespaces/default/apis/$_APINameRetailer/invoke/$queryLogin';
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





}


