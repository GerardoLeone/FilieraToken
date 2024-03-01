import 'dart:async' show Future;
import 'package:filiera_token_front_end/models/Product.dart';
import 'package:filiera_token_front_end/utils/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RetailerInventoryService {

  static Future<List<Product>> getCheesePieceList(String wallet) async {
    String url = API.buildURL(API.RetailerInventoryService, API.Query, "getListCheesePieceId");

    print(url);

    final headers = API.getHeaders();

    print(headers);

    final body = jsonEncode(API.getRetailerPayload(wallet));

    print(body);

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 202) {
        print(jsonEncode(response.body));

        final jsonData = jsonDecode(response.body);

        final List<String> idList = jsonData['output'].cast<String>();
        List<Product> productList = [];

        for (int i = 0; i < idList.length; i++) {
          Product product = await RetailerInventoryService.getCheesePiece(wallet, idList[i]);
          productList.add(product);
        }

        return productList;
      } else {
        throw Exception('Failed to fetch CheesePiece Id List: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching CheesePiece Id List: $error');
      rethrow;
    }
  }

  static Future<Product> getCheesePiece(String wallet, String id) async {
    String url = API.buildURL(API.RetailerInventoryService, API.Query, "getCheesePiece");
    final headers = API.getHeaders();
    final body = jsonEncode(API.getCheesePieceRetailerPayload(wallet, id));

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 202) {
        final jsonData = jsonDecode(response.body);

        return CheesePiece.fromJson(jsonData);
      } else {
        throw Exception('Failed to fetch CheesePiece: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching CheesePiece: $error');
      rethrow;
    }
  }

  static Future<bool> addCheesePiece(String wallet, double price, int quantity, String expirationDate) async {
    String url = API.buildURL(API.RetailerInventoryService, API.Query, "getCheesePiece");
    final headers = API.getHeaders();
    final body = jsonEncode(API.getCheesePieceBody(wallet, price.toString(), quantity.toString(), expirationDate));
    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 202) {
        return true;
      } else {
        throw Exception('Failed to add CheesePiece: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding CheesePiece: $error');
      rethrow;
    }
  }
}
