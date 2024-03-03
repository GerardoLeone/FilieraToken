import 'package:filiera_token_front_end/Actor/MilkHub/service/MilkHubInventoryService.dart';
import 'package:filiera_token_front_end/components/molecules/dialog/custom_alert_dialog.dart';
import 'package:flutter/material.dart';

class MilkBatchForm extends StatefulWidget {
  final String wallet;

  MilkBatchForm({required this.wallet});

  @override
  _MilkBatchFormState createState() => _MilkBatchFormState();
}

class _MilkBatchFormState extends State<MilkBatchForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _expirationDateController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  bool _loading = false;

  Future<void> _addMilkBatch() async {
    setState(() {
      _loading = true;
    });

    try {

      bool success = await MilkHubInventoryService.addMilkBatch(widget.wallet, _priceController.text, _quantityController.text, _expirationDateController.text);

      if (success) {
        CustomPopUpDialog.showMilkBatchAddSuccess(
          context,
          "Inserimento della Partita di Latte avvenuto con successo!",
        );
      } else {
        CustomPopUpDialog.showMilkBatchAddError(context);
      }
    } catch (error) {
      print("Errore durante l'aggiunta della Partita di Latte: $error");
      CustomPopUpDialog.showMilkBatchAddError(context);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Quantità'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Inserisci la quantità';
              }
              return null;
            },
          ),
          SizedBox(height: 8.0), // Aggiunto uno spazio tra i campi
          TextFormField(
            controller: _expirationDateController,
            decoration: InputDecoration(labelText: 'Scadenza'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Inserisci la data di scadenza';
              }
              return null;
            },
          ),
          SizedBox(height: 8.0), // Aggiunto uno spazio tra i campi
          TextFormField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Prezzo'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Inserisci il prezzo';
              }
              return null;
            },
          ),
          SizedBox(height: 16.0), // Aumentato lo spazio tra i campi e il pulsante
          ElevatedButton(
            onPressed: _loading
                ? null
                : () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      await _addMilkBatch();
                    }
                  },
            child: _loading
                ? CircularProgressIndicator()
                : Text('Invia'),
          ),
        ],
      ),
    );
}

}
