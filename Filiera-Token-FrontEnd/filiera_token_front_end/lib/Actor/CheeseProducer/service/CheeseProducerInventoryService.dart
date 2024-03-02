import 'dart:async' show Future;
import 'package:filiera_token_front_end/models/Product.dart';
import 'package:filiera_token_front_end/utils/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CheeseProducerInventoryService {

  static Future<List<Product>> getCheeseBlockList(String wallet) async {
    String url = API.buildURL(API.CheeseProducerNodePort, API.CheeseProducerInventoryService, API.Query, "getUserCheeseBlockIds");
    final headers = API.getHeaders();
    final body = jsonEncode(API.getCheeseProducerPayload(wallet));

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 202) {

        final jsonData = jsonDecode(response.body);

        final List<String> idList = jsonData['output'].cast<String>();
        List<Product> productList = [];

        for (int i = 0; i < idList.length; i++) {
          
          if(idList[i] == "0") {
            continue;
          }

          Product product = await CheeseProducerInventoryService.getCheeseBlock(wallet, idList[i]);
          productList.add(product);
        }

        return productList;
      } else {
        throw Exception('Failed to fetch CheeseBlock Id List: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching CheeseBlock Id List: $error');
      rethrow;
    }
  }

  static Future<Product> getCheeseBlock(String wallet, String id) async {
    String url = API.buildURL(API.CheeseProducerNodePort, API.CheeseProducerInventoryService, API.Query, "getCheeseBlock");
    final headers = API.getHeaders();
    final body = jsonEncode(API.getCheeseBlockPayload(wallet, id));
    print("---------------------------------");
    print("[URL]: $url\n");
    print("[HEADERS]: $headers\n");
    print("[BODY]: $body\n");
    print("---------------------------------");

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 202) {
        final jsonData = jsonDecode(response.body);

        return CheeseBlock.fromJson(jsonData);
      } else {
        throw Exception('Failed to fetch CheeseBlock: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching CheeseBlock: $error');
      rethrow;
    }
  }

  static Future<bool> transformMilkBatch(String wallet, String idMilkBatch, String quantityToTransform, String pricePerKg, String dop) async {
    String url = API.buildURL(API.CheeseProducerNodePort, API.CheeseProducerInventoryService, API.Invoke, "transformMilkBatch");
    final headers = API.getHeaders();
    final body = jsonEncode(API.getTransformCheeseProducerBody(dop, idMilkBatch, pricePerKg, quantityToTransform, wallet));
    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 202) {        
        return true;
      } else {
          throw Exception('Failed to transform MilkBatch in CheeseBlock: ${response.statusCode}');
      }

    } catch (error) {
      print('Error transforming MilkBatch in CheeseBlock: $error');
      rethrow;
    }
  }
}
