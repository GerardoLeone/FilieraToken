import 'package:filiera_token_front_end/components/molecules/dialog/custom_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:filiera_token_front_end/models/Product.dart';

class DialogConversionCenter extends StatefulWidget {
  Product product;

  DialogConversionCenter({
    required this.product,
  });

  @override
  _DialogConversionCenterState createState() => _DialogConversionCenterState();
}

class _DialogConversionCenterState extends State<DialogConversionCenter> {



  TextEditingController ?_quantityToConvert;


  late String quantityValue;

  @override
  void initState() {
    _quantityToConvert = TextEditingController();
    super.initState();
    quantityValue = '';
  }

  @override
  void dispose() {

    _quantityToConvert?.dispose();
    super.dispose();
    quantityValue = '';
  }


  Widget _buildConvertButton(){
    return ElevatedButton(

              child: Text('Convert'),
              onPressed: () {
                /*if (quantityToConvert!.text.validate()) {
                  print('Valore nel form: $quantityValue');

                  Product originalProduct = widget.product;
                  Product convertedProduct;

                  int newQuantity = int.parse(quantityValue) * 2;
                  originalProduct.updateQuantity(int.parse(quantityValue));

                  if (originalProduct is MilkBatch) {
                    convertedProduct = CheeseBlock(
                      id: originalProduct.id,
                      name: originalProduct.name,
                      description: originalProduct.description,
                      seller: originalProduct.seller,
                      dop: "dop",
                      price: 500, //TODO: far inserire il prezzo manualmente
                      quantity: newQuantity,
                    );
                  } else if (originalProduct is CheeseBlock) {

                    for(int i = 0; i < int.parse(quantityValue); i++) {
                      convertedProduct = CheesePiece(
                        id: originalProduct.id,
                        name: originalProduct.name,
                        description: originalProduct.description,
                        seller: originalProduct.seller,
                        price: 10,
                        weight: 1,
                      );

                      //TODO: iterazione aggiungere l'oggetto nella lista Inventory (Service)
                    }
                  }*/
                  //TODO: aggiungere convertedProduct alla lista Inventory (Service)
                  Navigator.of(context).pop();
                  CustomPopUpDialog.showConversionSuccess(context, "La conversione è avvenuta con successo!");
              }
            );
  }

  Widget _buildTextForm(){
    return TextField(
              decoration: 
               InputDecoration(
                labelText:'Quantità da convertire:',
                labelStyle:TextStyle(color: Colors.white, fontWeight: FontWeight.bold )
                ),
              controller: _quantityToConvert,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            );
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
            _buildTextForm(),
            SizedBox(height: 30),
            _buildConvertButton()
          ],
        ),
    );
  }




}
