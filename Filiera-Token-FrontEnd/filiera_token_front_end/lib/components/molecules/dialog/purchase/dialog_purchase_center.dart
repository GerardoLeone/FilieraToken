import 'package:filiera_token_front_end/components/molecules/dialog/custom_alert_dialog.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/services/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:filiera_token_front_end/models/Product.dart';

class DialogPurchaseCenter extends StatefulWidget {
  final Product product;
  final String userType;
  final String buyer;

  DialogPurchaseCenter({
    required this.product, 
    required this.userType,
    required this.buyer
  });

  @override
  _DialogPurchaseCenterState createState() => _DialogPurchaseCenterState();
}

class _DialogPurchaseCenterState extends State<DialogPurchaseCenter> {



  TransactionService transactionService = TransactionService();
  



  TextEditingController ?_quantityToBuy;

  @override
  void dispose() {
    _quantityToBuy?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _quantityToBuy = TextEditingController();
    super.initState();
  }

  
  Widget _buildBuyButton(){
    return ElevatedButton(
              onPressed: () {
                Product productToBuy = widget.product;
                // BuyLogic 
                switch(widget.userType){
                  case "Consumer":{

                  }
                  case "CheeseProducer":{
                    // Converto e calcolo il prezzo totale 
                    String quantityToBuy = _quantityToBuy!.text;
                    print("Sono nel metodo di acquisto!");
                    int totalPrice = int.parse(quantityToBuy) * int.parse(productToBuy.getUnitPrice().toString());
                    print("Prezzo totale :"+totalPrice.toString());
                    String priceToPay = totalPrice.toString();

                    print("Product Seller : "+productToBuy.seller);
                    print("Product buyer:"+widget!.buyer);
                    if(transactionService.buyMilkBatchProduct( productToBuy.id, quantityToBuy,widget.buyer,productToBuy.seller,priceToPay )==true  && (int.parse(_quantityToBuy!.text)<= productToBuy.getQuantity()) ){
                            // Show success Transaction 
                            CustomPopUpDialog.showBuyMilkBatchSuccess(context, "Transazione avvenuta con successo!");

                    }else{
                      CustomPopUpDialog.showBuyMilkBatchError(context);
                    }


                  }
                  case "Retailer":{

                  }
                }
              },
              child: Text('Buy'),
      );
  }

  Widget _buidlTextForm(){
    return TextField(
              decoration: 
               InputDecoration(
                labelText:'Quantità richiesta:',
                labelStyle:TextStyle(color: Colors.white, fontWeight: FontWeight.bold )
                ),
              controller: _quantityToBuy,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            );
    /*Text(
              'Quantità richiesta:',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  quantityValue = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Inserisci una quantità';
                }

                int enteredQuantity = int.parse(value);
                int originalQuantity = widget.product.getQuantity();

                if (enteredQuantity > originalQuantity) {
                  return 'Quantità invalida.';
                }

                return null;
              },
            );*/
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buidlTextForm(),
            SizedBox(height: 30),
            _buildBuyButton()
          ],
        ),
      );
  }
}
