import 'dart:async' show Future;
import 'package:filiera_token_front_end/models/Product.dart';
import 'package:filiera_token_front_end/utils/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MilkHubInventoryService {

  /**
   * Questa funzione restituisce una lista di MilkBatch a partire dal wallet del MilkHub che li possiede.
   */
  static Future<List<Product>> getMilkBatchList(String wallet) async {
    
    String url = API.buildURL(API.MilkHubInventoryService, API.Query, "getListMilkBatchIdByMilkHub");
    final headers = API.getHeaders();
    final body = jsonEncode(API.getMilkHubPayload(wallet)); // Prepare JSON body with wallet data

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 202) {

        print(jsonEncode(response.body));

        final jsonData = jsonDecode(response.body);

        final List<String> idList = jsonData['output'].cast<String>();
        List<Product> productList = [];

        for (int i = 0; i < idList.length; i++) {
          Product product = await MilkHubInventoryService.getMilkBatch(wallet, idList[i]);
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
  static Future<Product> getMilkBatch(String wallet, String id) async {
    String url = API.buildURL(API.MilkHubInventoryService, API.Query, "getMilkBatch");
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
  static Future<bool> addMilkBatch(String wallet, double price, int quantity, String expirationDate) async {
    String url = API.buildURL(API.MilkHubInventoryService, API.Query, "getMilkBatch");
    final headers = API.getHeaders();
    final body = jsonEncode(API.getMilkBatchBody(wallet, price.toString(), quantity.toString(), expirationDate));
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