import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:filiera_token_front_end/models/Product.dart';

class DialogConversionCenter extends StatefulWidget {
  final Product product;
  final TextEditingController quantityController;

  DialogConversionCenter({
    required this.product,
    required this.quantityController,
  });

  @override
  _DialogConversionCenterState createState() => _DialogConversionCenterState();
}

class _DialogConversionCenterState extends State<DialogConversionCenter> {
  late String quantityValue; // Stato per memorizzare il valore del campo di input

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quantità da convertire:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: TextStyle(color: Colors.white),
            onChanged: (value) {
              // Aggiorna lo stato quando il campo di input cambia
              setState(() {
                quantityValue = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              // Utilizza il valore del campo di input quando il pulsante viene premuto
              print('Valore nel form: $quantityValue');
            },
            child: Text('Convert'),
          ),
        ],
      ),
    );
  }
}
