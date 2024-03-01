import 'dart:async' show Future;
import 'package:filiera_token_front_end/models/Product.dart';
import 'package:filiera_token_front_end/utils/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CheeseProducerInventoryService {

  static Future<List<Product>> getCheeseBlockList(String wallet) async {
    String url = API.buildURL(API.CheeseProducerInventoryService, API.Query, "getListCheeseBlockId");

    print(url);

    final headers = API.getHeaders();

    print(headers);

    final body = jsonEncode(API.getCheeseProducerPayload(wallet));

    print(body);

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 202) {
        print(jsonEncode(response.body));

        final jsonData = jsonDecode(response.body);

        final List<String> idList = jsonData['output'].cast<String>();
        List<Product> productList = [];

        for (int i = 0; i < idList.length; i++) {
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
    String url = API.buildURL(API.CheeseProducerInventoryService, API.Query, "getCheeseBlock");
    final headers = API.getHeaders();
    final body = jsonEncode(API.getCheeseBlockPayload(wallet, id));

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

  static Future<bool> addCheeseBlock(String wallet, String milkBatchId, String dop, String quantity, String price) async {
    String url = API.buildURL(API.CheeseProducerInventoryService, API.Query, "getCheeseBlock");
    final headers = API.getHeaders();
    final body = jsonEncode(API.getCheeseBlockBody(wallet, milkBatchId, dop, quantity, price));
    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 202) {
        return true;
      } else {
        throw Exception('Failed to add CheeseBlock: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding CheeseBlock: $error');
      rethrow;
    }
  }
}
