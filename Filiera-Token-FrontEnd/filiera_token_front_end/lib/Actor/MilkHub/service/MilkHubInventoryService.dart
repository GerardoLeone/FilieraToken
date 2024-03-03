import 'dart:async' show Future;
import 'package:filiera_token_front_end/models/Product.dart';
import 'package:filiera_token_front_end/utils/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MilkHubInventoryService {

  /**
   * Questa funzione restituisce una lista di MilkBatch a partire dal wallet del MilkHub che li possiede.
   */
  Future<List<Product>> getMilkBatchList(String walletMilkHub) async {
    String url = API.buildURL(API.MilkHubNodePort, API.MilkHubInventoryService, API.Query, "getUserMilkBatchIds");
    final headers = API.getHeaders();
    final body = jsonEncode(API.getMilkHubPayload(walletMilkHub)); // Prepare JSON body with wallet data

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 202) {

        print(jsonEncode(response.body));

        final jsonData = jsonDecode(response.body);

        final List<String> idList = jsonData['output'].cast<String>();
        List<Product> productList = [];

        for (int i = 0; i < idList.length; i++) {
          Product product = await getMilkBatch(walletMilkHub, idList[i]);
          productList.add(product);
        }

        return productList;
      } else {
        throw Exception('Failed to fetch MilkBatch Id List: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching MilkBatch Id List: $error');
      rethrow; // Re-throw to allow external handling of errors
    }
  }


  /**
   * Questa funzione restituisce una lista di MilkBatch a partire dal wallet del MilkHub che li possiede.
   */
  Future<List<Product>> getMilkBatchListAll(String walletCheeseProducer) async {

    //TODO : Call to Address list of Milkhub to get all Address List 
    String url = API.buildURL(API.CheeseProducerNodePort, API.MilkHubInventoryService, API.Query, "getGlobalMilkBatchIds");
    final headers = API.getHeaders();
    final body = jsonEncode(API.getCheeseProducerPayload(walletCheeseProducer)); // Prepare JSON body with wallet data

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 202) {

        print(jsonEncode(response.body));

        final jsonData = jsonDecode(response.body);

        final List<String> idList = jsonData['output'].cast<String>();
        List<Product> productList = [];
        // TODO : For sulla lista degli address dei Milkhub 
        // TODO : Mi recupero le liste degli elementi per ogni milkhub e metto nella lista dei prodotti 
        for (int i = 0; i < idList.length; i++) {
          Product product = await getMilkBatch(walletCheeseProducer, idList[i]);
          productList.add(product);
        }

        return productList;
      } else {
        throw Exception('Failed to fetch MilkBatch Id List: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching MilkBatch Id List: $error');
      rethrow; // Re-throw to allow external handling of errors
    }
  }

  /**
   * Questa funzione restituisce un MilkBatch a partire dal wallet che lo possiede e dall'identificativo.
   */
  Future<Product> getMilkBatch(String wallet, String id) async {
    String url = API.buildURL(API.MilkHubNodePort, API.MilkHubInventoryService, API.Query, "getMilkBatch");
    final headers = API.getHeaders();
    final body = jsonEncode(API.getMilkBatchPayload(wallet, id));

      print(url);
    print(headers);
    print(body);

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 202) {
        final jsonData = jsonDecode(response.body);

        return MilkBatch.fromJson(jsonData);
      } else {
          throw Exception('Failed to fetch MilkBatch: ${response.statusCode}');
      }

    } catch (error) {
      print('Error fetching MilkBatch: $error');
      rethrow; // Re-throw to allow external handling of errors
    }

  }

  /**
   * Questa funzione permette di aggiungere un MilkBatch all'interno del sistema, restituendo true se va a buon fine, false altrimenti.
   */
  static Future<bool> addMilkBatch(String wallet, String price, String quantity, String expirationDate) async {
    String url = API.buildURL(API.MilkHubNodePort, API.MilkHubInventoryService, API.Invoke, "getMilkBatch");
    final headers = API.getHeaders();
    final body = jsonEncode(API.getMilkBatchBody(wallet, price, quantity, expirationDate));
    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 202) {        
        return true;
      } else {
          throw Exception('Failed to add MilkBatch: ${response.statusCode}');
      }

    } catch (error) {
      print('Error adding MilkBatch: $error');
      rethrow;
    }
  }

}