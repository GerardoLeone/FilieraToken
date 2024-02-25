import 'package:filiera_token_front_end/components/molecules/custom_alert_dialog.dart';
import 'package:filiera_token_front_end/models/Product.dart';
import 'package:flutter/material.dart';

class MilkBatchForm extends StatefulWidget {
  @override
  _MilkBatchFormState createState() => _MilkBatchFormState();
}

class _MilkBatchFormState extends State<MilkBatchForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _expirationDateController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Nome'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Inserisci il nome';
              }
              return null;
            },
          ),
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
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Descrizione'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Inserisci la descrizione';
              }
              return null;
            },
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                // Dati del form validi, esegui l'azione desiderata
                // Esempio: creazione di un oggetto MilkBatch
                Product milkBatch = MilkBatch(
                  id: 1, //TODO: Sostituisci con la logica per generare un ID univoco
                  name: _nameController.text,
                  description: _descriptionController.text,
                  seller: "Nome del Seller", //TODO: Sostituisci con la logica per ottenere il seller
                  quantity: int.parse(_quantityController.text),
                  expirationDate: _expirationDateController.text,
                  pricePerLitre: double.parse(_priceController.text),
                );

                // TODO: inserire nella lista dell'inventario

                // Resetta i controller dopo l'invio del form
                _nameController.clear();
                _quantityController.clear();
                _expirationDateController.clear();
                _priceController.clear();
                _descriptionController.clear();


                // Chiudi il form
                Navigator.of(context).pop();
                CustomPopUpDialog.showMilkBatchAddSuccess(context, "Inserimento della Partita di Latte avvenuto con successo!");
              }
            },
            child: Text('Invia'),
          ),
        ],
      ),
    );
  }
}
