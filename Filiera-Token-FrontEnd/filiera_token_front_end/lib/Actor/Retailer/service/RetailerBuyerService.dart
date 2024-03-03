
import 'dart:convert';

import 'package:filiera_token_front_end/models/Product.dart';
import 'package:filiera_token_front_end/utils/api.dart';
import 'package:http/http.dart' as http;


class RetailerBuyerService {

  static const String _queryGetCheeseBlockListIDPurchase="getUserCheeseBlockIds";

  static const String _queryGetCheeseBlock ="getCheeseBlock";


  Future<List<Product>> getCheeseBlockList(String wallet) async {
    String url = API.buildURL(API.RetailerNodePort,API.RetailerBuyerService, API.Query, _queryGetCheeseBlockListIDPurchase);

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

        print("List : "+idList.toString());
        List<Product> productList = [];

        for (int i = 0; i < idList.length; i++) {
          Product product = await getCheeseBlock(idList[i],wallet);
          productList.add(product);
        }

        return productList;
      } else {
        throw Exception('Failed to fetch CheeseBlock Id List: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching CheesePiece Id List: $error');
      rethrow;
    }
  }


  Future<Product> getCheeseBlock(String cheeseId, String walletRetailer) async {
    
    String url = API.buildURL(API.RetailerNodePort,API.RetailerBuyerStorage, API.Query, _queryGetCheeseBlock);
    
    final body = jsonEncode(API.getCheeseBlockForRetailerBody(cheeseId, walletRetailer));
    final headers = API.getHeaders();

    final response = await http.post(Uri.parse(url), body: body, headers: headers);

    if(response.statusCode == 200){
      print(response.toString());
      
      final jsonData = jsonDecode(response.body);

      return CheeseBlock.fromJson(jsonData);
    }else{
        throw Exception('Failed to fetch CheesePiece Id List: ${response.statusCode}');
    }
  }








}