import 'package:flutter/material.dart';

class DialogConversionRight extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Allinea il pulsante a destra
        children: [
          Spacer(),
          ElevatedButton(
            onPressed: () {
              // Azioni del pulsante
            },
            child: Text('Convert'),
          ),
        ],
      ),
    );
  }
}
