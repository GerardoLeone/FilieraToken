import 'dart:convert';
import 'package:filiera_token_front_end/utils/api.dart';
import 'package:http/http.dart' as http;


class TransactionService {


Future<bool> buyMilkBatchProduct(
  String milkBatchId,
   String quantityToBuy,
   String buyer,
   String ownerMilkBatch,
   String totalPrice,
) async {

  print("Sono nel metodo di Acquisto finale!");
  var url = Uri.parse(API.buildURL(API.CheeseProducerNodePort,API.TransactionBuyMilkBatchService , API.Invoke, "BuyMilkBatchProduct"));

  var body = jsonEncode(API.buyMilkBatchProductBody(milkBatchId, quantityToBuy, buyer, ownerMilkBatch, totalPrice));

  try {
    var response = await http.post(
      url,
      headers: API.getHeaders(),
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 202) {
      // Transazione è stata effettuata con successo 
      print('Risposta: ${response.body}');
      return true;

    } else {
      print('Errore: ${response.statusCode}');
      print('Messaggio di errore: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Errore durante la richiesta: $e');
    return false;
  }
}



Future<bool> buyCheeseBlockProduct(
   String cheeseBlockId,
   String quantityToBuy,
   String buyer,
   String ownerMilkBatch,
   String totalPrice,
) async {
  var url = Uri.parse(API.buildURL(API.RetailerNodePort,API.TransactionBuyCheeseService , API.Invoke, "BuyCheeseProduct"));
  var body = jsonEncode(API.buyCheeseBlockProductBody(cheeseBlockId, quantityToBuy, buyer, ownerMilkBatch, totalPrice));
  var header = API.getHeaders();

  try {
    var response = await http.post(
      url,
      headers: header,
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 202) {
      print('Risposta: ${response.body}');
      return true;
    } else {
      print('Errore: ${response.statusCode}');
      print('Messaggio di errore: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Errore durante la richiesta: $e');
    return false;
  }
}



void buyCheesePieceProduct({
  required String milkBatchId,
  required String quantityToBuy,
  required String buyer,
  required String ownerMilkBatch,
  required String totalPrice,
}) async {
  var url = Uri.parse('http://127.0.0.1:5000/api/v1/namespaces/default/apis/TransactionBuyMilkBatchService/invoke/BuyMilkBatchProduct');

  var body = jsonEncode({
    "input": {
      "_id_MilkBatch": milkBatchId,
      "_quantityToBuy": quantityToBuy,
      "buyer": buyer,
      "ownerMilkBatch": ownerMilkBatch,
      "totalPrice": totalPrice
    },
  });

  try {
    var response = await http.post(
      url,
      headers: {
        'accept': 'application/json',
        'Request-Timeout': '2m0s',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print('Risposta: ${response.body}');
    } else {
      print('Errore: ${response.statusCode}');
      print('Messaggio di errore: ${response.body}');
    }
  } catch (e) {
    print('Errore durante la richiesta: $e');
  }
}




  
}