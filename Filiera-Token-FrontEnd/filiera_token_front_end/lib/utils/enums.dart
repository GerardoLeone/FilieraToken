enum CustomType { neutral, danger, warning, success }

enum Actor { MilkHub, CheeseProducer, Retailer, Consumer, unknown }

enum Asset { MilkBatch, CheeseBlock, CheesePiece }

enum DialogType { DialogConversion, DialogPurchase }

class Enums {
  
  /*
  *   Questa funzione restituisce un testo di default basandosi sull'Actor dati in input
  */
  static String getActorText(Actor actor) {
    switch(actor) {
      case Actor.MilkHub:
        return "MilkHub";
      case Actor.CheeseProducer:
        return "CheeseProducer";
      case Actor.Retailer:
        return "Retailer";
      case Actor.Consumer:
        return "Consumer";
      case Actor.unknown:
        return "";
    }
  }

  /*
   *  Questa funzione restituisce un testo di default basandosi sul CustomType
   */
  static String getDefaultText(CustomType type) {
    switch (type) {
      case CustomType.neutral:
        return "Conferma";
      case CustomType.danger:
        return "Cancella";
      case CustomType.warning:
        return "Annulla";
      case CustomType.success:
        return "OK";
    }
  }

  /*
   *  Questa funzione restituisce il path di un asset passato in input 
   */
  static String getAssetPath(Asset asset) {
    switch(asset) {
      case Asset.MilkBatch:
        return "milk.png";
      case Asset.CheeseBlock:
        return "cheese_block.png";
      case Asset.CheesePiece:
        return "cheese_piece.png";
    }
  }

  /*
  *   Questa funzione restituisce un id basandosi sull'Actor dati in input
  */
  static int getActorId(Actor actor) {
    switch(actor) {
      case Actor.MilkHub:
        return 1;
      case Actor.CheeseProducer:
        return 2;
      case Actor.Retailer:
        return 3;
      case Actor.Consumer:
        return 4;
      case Actor.unknown:
        return 0;
    }
  } 

}