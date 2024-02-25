import 'package:filiera_token_front_end/components/molecules/dialog/custom_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:filiera_token_front_end/models/Product.dart';

class DialogPurchaseCenter extends StatefulWidget {
  Product product;

  DialogPurchaseCenter({
    required this.product,
  });

  @override
  _DialogPurchaseCenterState createState() => _DialogPurchaseCenterState();
}

class _DialogPurchaseCenterState extends State<DialogPurchaseCenter> {
  



  TextEditingController ?_quantityToBuy;
  late String quantityValue;

  @override
  void dispose() {
    _quantityToBuy?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _quantityToBuy = TextEditingController();
    super.initState();
    quantityValue = '';
  }

  
  Widget _buildBuyButton(){
    return ElevatedButton(
              onPressed: () {
                /*if (_formKey.currentState!.validate()) {
                  print('Valore nel form: $quantityValue');

                  //TODO: aggiungere convertedProduct alla lista Inventory (Service)

                  Navigator.of(context).pop();
                  CustomPopUpDialog.showConversionSuccess(context, "La conversione è avvenuta con successo!");
                }*/
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
