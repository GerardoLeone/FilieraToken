import 'package:filiera_token_front_end/components/molecules/custom_alert_dialog.dart';
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
  late String quantityValue;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    quantityValue = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
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
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  print('Valore nel form: $quantityValue');

                  //TODO: aggiungere convertedProduct alla lista Inventory (Service)

                  Navigator.of(context).pop();
                  CustomPopUpDialog.showConversionSuccess(context, "La conversione è avvenuta con successo!");
                }
              },
              child: Text('Buy'),
            ),
          ],
        ),
      ),
    );
  }
}
