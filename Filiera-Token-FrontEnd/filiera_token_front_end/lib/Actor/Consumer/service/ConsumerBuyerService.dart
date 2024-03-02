import 'dart:async' show Future;
import 'package:filiera_token_front_end/models/Product.dart';
import 'package:filiera_token_front_end/utils/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConsumerBuyerService {


  static const String _queryListProductIDPurchased ='getUserCheesePieceIds';

  static const String _queryCheesePiece="getCheesePiece";


  Future<List<Product>> getCheesePieceList(String wallet) async {
    String url = API.buildURL(API.ConsumerBuyerInventoryService, API.Query, _queryListProductIDPurchased);

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
          Product product = await getCheesePiece(idList[i],wallet);
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


  Future<Product> getCheesePiece(String cheeseId, String walletConsumerBuyer) async {
    
    String url = API.buildURL(API.ConsumerBuyerInventoryService, API.Query, _queryCheesePiece);
    
    final body = jsonEncode(API.getCheesePieceForConsumerBody(cheeseId, walletConsumerBuyer));
    final headers = API.getHeaders();

    final response = await http.post(Uri.parse(url), body: body, headers: headers);

    if(response.statusCode == 200){
      print(response.toString());
      
      final jsonData = jsonDecode(response.body);

      return CheesePiece.fromJson(jsonData);
    }else{
        throw Exception('Failed to fetch CheesePiece Id List: ${response.statusCode}');
    }
  }


 





}
