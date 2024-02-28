import 'dart:async' show Future;
import 'package:filiera_token_front_end/models/Product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MilkHubInventoryService {

  static const String _apiUrl = 'http://127.0.0.1:5000/api/v1/namespaces/default/apis/MilkHubInventoryService';

  static const String _APINameMilkHub = "MilkHubInventoryService";

  static const String _APINameCheeseProducer = "CheeseProducerInventoryService";

  static const String _APINameRetailer = "RetailerInventoryService";

  static const String _APINameConsumer = "ConsumerInventoryService";


//getMilkHubId per calcolare wallet
//gestire double
//Name fissa e togliere la description
  Future<List<Product>> getMilkBatchListByMilkHub(String wallet) async {
    const url = '$_apiUrl/query/getMilkBatchListByMilkHub';
    final headers = _getHeaders();

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final jsonList = jsonDecode(response.body) as List;

        // Parse JSON list into Product objects
        final productList = jsonList.map((json) => MilkBatch.fromJson(json)).toList();

        return productList;
      } else {
        throw Exception('Failed to fetch products: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching products: $error');
      rethrow; // Re-throw to allow external handling of errors
    }
  }


//aggiungere name e description
//TODO: da cambiare
  Future<bool> addMilkBatch(double price, int quantity, String expirationDate) async {

    const url = '$_apiUrl/invoke/addMilkBatch';
    final headers = _getHeaders();
    final body = _getMilkBatchBody(price, quantity, expirationDate);

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 202) {
      // Richiesta avvenuta con successo
      print('Partita di Latte aggiunta con successo');
      return true;
    } else {
      // Errore nella richiesta
      final error = jsonDecode(response.body)['error'];
      print('Partita di Latte non aggiunta!' + error);
      return false;
    }
  }

  Map<String, String> _getHeaders() {
    return {
      'Accept': 'application/json',
      'Request-Timeout': '2m0s',
      'Content-Type': 'application/json',
    };
  }

  Map<String, dynamic> _getMilkBatchBody(double price, int quantity, String expirationDate){
    return {
      'input': {
        'price': price,
        'quantity': quantity,
        'expirationDate': expirationDate
      }
    };
  }
  
  Map<String, dynamic> _getMilkBatchPayload(int id) {
    return {
      "input": {
        "id": id,
      }
    };
  }


}