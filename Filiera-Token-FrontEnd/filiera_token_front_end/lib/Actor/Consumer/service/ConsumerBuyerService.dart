import 'dart:async' show Future;
import 'package:filiera_token_front_end/models/Product.dart';
import 'package:filiera_token_front_end/utils/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConsumerBuyerService {

  static Future<List<Product>> getCheesePieceList(String wallet) async {
    String url = API.buildURL(API.ConsumerNodePort, API.ConsumerBuyerInventoryService, API.Query, "getUserCheesePieceIds");

    print(url);

    final headers = API.getHeaders();

    print(headers);

    final body = jsonEncode(API.getConsumerPayload(wallet));

    print(body);

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 202) {
        print(jsonEncode(response.body));

        final jsonData = jsonDecode(response.body);

        final List<String> idList = jsonData['output'].cast<String>();

        print("List : "+idList.toString());
        List<Product> productList = [];

        for (int i = 0; i < idList.length; i++) {
          Product product = await ConsumerBuyerService.getCheesePiece(idList[i],wallet);
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

  /*static Future<Product> getCheesePiece(String wallet, String id) async {
    String url = API.buildURL(API.ConsumerNodePort, API.ConsumerBuyerInventoryService, API.Query, "getCheesePiece");
    final headers = API.getHeaders();
    final body = jsonEncode(API.getCheesePieceConsumerPayload(wallet, id));

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
  }*/


  // Effettuo una chiamata di prova per cercare di aggiungere i prodotti 

  Future<Product> addCheesePiece(String id, String price, String walletConsumerBuyer, String walletRetailer, String weight) async {
    final url = API.buildURL(API.ConsumerNodePort, API.ConsumerBuyerInventoryService, API.Invoke, "addCheesePiece");
    
    final body = jsonEncode({
      'input': {
        '_id': id,
        '_price': price,
        '_walletConsumerBuyer': walletConsumerBuyer,
        '_walletRetailer': walletRetailer,
        '_weight': weight,
      },
    });
    final headers = API.getHeaders();
      try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 202) {
        final jsonData = jsonDecode(response.body);

        print(jsonData);

        return CheesePiece.fromJson(jsonData);
      } else {
        throw Exception('Failed to fetch CheesePiece: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching CheesePiece: $error');
      rethrow;
    }
  }




  static Future<Product> getCheesePiece(String cheeseId, String walletConsumerBuyer) async {
    
    String url = API.buildURL(API.ConsumerNodePort, API.ConsumerBuyerInventoryService, API.Query, "getCheesePiece");
    
    final body = jsonEncode(API.getCheesePiecePayload(cheeseId, walletConsumerBuyer));
    final headers = API.getHeaders();

    final response = await http.post(Uri.parse(url), body: body, headers: headers);

    print(response.toString());
    final jsonData = jsonDecode(response.body);
    
    return CheesePiece.fromJson(jsonData);
  }
}
