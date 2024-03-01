class API {

  /**
   * URL API
   */
  static const String URL = "http://127.0.0.1:5000/api/v1/namespaces/default/apis/";
  static const String Invoke = "invoke/";
  static const String Query = "query/";

  /**
   * Costanti MilkHub
   */
  static const String MilkHubService = "MilkHubService";
  static const String MilkHubInventoryService = "MilkHubInventoryService";

  /**
   * Costanti CheeseProducer
   */
  static const String CheeseProducerService = "CheeseProducerService";
  static const String CheeseProducerInventoryService = "CheeseProducerInventoryService";

  /**
   * Costanti Retailer
   */
  static const String RetailerService = "RetailerService";
  static const String RetailerInventoryService = "RetailerInventoryService";

  /**
   * Costanti Consumer
   */
  static const String ConsumerService = "ConsumerService";
  static const String ConsumerBuyerInventoryService = "ConsumerBuyerInventoryService";

  /**
   * Questa funzione permette di costruire l'URL per la chiamata di un metodo dell'API utilizzando le costanti offerte dalla classe api.dart
   * 
   * @param interface: definisce il nome dell'interfaccia da richiamare (per esempio un Service).
   * @param callType: per scrittura URL.Invoke, per lettura URL.Query.
   * @param methodName: nome del metodo all'interno dell'interfaccia.
   */
  static String buildURL(String interface, String callType, String methodName) => (API.URL + interface + "/" + callType + methodName);

  static Map<String, String> getHeaders() {
    return {
      'Accept': 'application/json',
      'Request-Timeout': '2m0s',
      'Content-Type': 'application/json',
    };
  }

//Payload (Get) ---------------------------------------------------------------------------------------------------------------------------------------

  static Map<String, dynamic> getMilkHubPayload(String wallet){
    return {
      'input': {
        'walletMilkHub': wallet,
      }
    };
  }

  static Map<String, dynamic> getMilkBatchPayload(String wallet, String id){
    return {
      'input': {
        'id': id,
        'walletMilkHub': wallet
      }
    };
  }

  static Map<String, dynamic> getCheeseProducerPayload(String wallet){
    return {
      'input': {
        'walletCheeseProducer': wallet,
      }
    };
  }  

  static Map<String, dynamic> getCheeseBlockPayload(String wallet, String id){
    return {
      'input': {
        'id': id,
        'walletCheeseProducer': wallet
      }
    };
  }

  static Map<String, dynamic> getRetailerPayload(String wallet){
    return {
      'input': {
        'walletRetailer': wallet,
      }
    };
  }  

  static Map<String, dynamic> getCheesePieceRetailerPayload(String wallet, String id){
    return {
      'input': {
        'id': id,
        'walletRetailer': wallet
      }
    };
  }

  static Map<String, dynamic> getConsumerPayload(String wallet){
    return {
      'input': {
        'walletConsumer': wallet,
      }
    };
  }

  static Map<String, dynamic> getCheesePieceConsumerPayload(String wallet, String id){
    return {
      'input': {
        'id': id,
        'walletConsumer': wallet
      }
    };
  }
  

//Body (Add) ---------------------------------------------------------------------------------------------------------------------------------------

  static Map<String, dynamic> getMilkBatchBody(String wallet, String price, String quantity, String expirationDate){
    return {
      'input': {
        'price': price,
        'quantity': quantity,
        'scadenza': expirationDate,
        'walletMilkHub': wallet
      }
    };
  } 

  static Map<String, dynamic> getCheeseBlockBody(String wallet, String milkBatchId, String dop, String quantity, String price) {
    return {
      'input': {
        'id_MilkBatchAcquistato': milkBatchId,
        'dop': dop,
        'quantity': quantity,
        'price': price,
        'walletCheeseProducer': wallet,
      }
    };
  }

  static Map<String, dynamic> getCheesePieceBody(String wallet, String cheeseBlockId, String price, String weight) {
    return {
      'input': {
        'id_CheeseBlock': cheeseBlockId,
        'price': price,
        'weight': weight
      }
    };
  }
  

}