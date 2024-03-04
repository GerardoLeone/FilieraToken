import 'package:filiera_token_front_end/components/molecules/custom_loading_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:filiera_token_front_end/models/Product.dart';
import 'package:filiera_token_front_end/Actor/CheeseProducer/service/CheeseProducerInventoryService.dart';
import 'package:filiera_token_front_end/Actor/Retailer/service/RetailerInventoryService.dart';
import 'package:filiera_token_front_end/components/molecules/dialog/custom_alert_dialog.dart';

class DialogConversionCenter extends StatefulWidget {
  Product product;
  String wallet;

  DialogConversionCenter({
    required this.product,
    required this.wallet,
  });

  @override
  _DialogConversionCenterState createState() => _DialogConversionCenterState();
}

class _DialogConversionCenterState extends State<DialogConversionCenter> {
  TextEditingController? _quantityToConvert;
  late String quantityValue;
  bool _loading = false;

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

  Future<void> _convertProduct() async {
    setState(() {
      _loading = true;
    });

    Product product = widget.product;
    bool conversionSuccess = false;

    try {
      if (product is MilkBatch) {
        CheeseProducerInventoryService cheeseProducerInventoryService =
            CheeseProducerInventoryService();
        conversionSuccess = await cheeseProducerInventoryService.transformMilkBatch(
            widget.wallet, product.id, quantityValue, product.pricePerLitre.toString(), "DOP");
      } else if (product is CheeseBlock) {
        RetailerInventoryService retailerInventoryService =
            RetailerInventoryService();
        conversionSuccess = await retailerInventoryService.transformCheesePiece(
            widget.wallet, product.price.toString(), quantityValue, product.getExpirationDate());
      }
    } catch (error) {
      // Gestisci l'errore qui, mostra un alert dialog o esegui altre azioni necessarie
      print("Errore durante la conversione: $error");
      CustomPopUpDialog.showConversionError(context);
    } finally {
      // Assicurati che la barra di caricamento venga rimossa anche in caso di errore
      setState(() {
        _loading = false;
      });
    }

    if (conversionSuccess) {
      Navigator.of(context).pop();
      CustomPopUpDialog.showConversionSuccess(
          context, "La conversione è avvenuta con successo!");
    }
  }

  Widget _buildConvertButton() {
    return ElevatedButton(
      child: Text('Convert'),
      onPressed: _loading ? () {} : _convertProduct,
    );
  }

  Widget _buildTextForm() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Quantità da convertire:',
        labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
          _loading
              ? CustomLoadingIndicator(progress: 0.5)
              : _buildConvertButton(),
        ],
      ),
    );
  }
}



class DialogConversionCenterPurchased extends StatefulWidget {
  ProductPurchased product;
  String wallet;

  DialogConversionCenterPurchased({
    required this.product,
    required this.wallet,
  });

  @override
  _DialogConversionCenterStatePurchased createState() => _DialogConversionCenterStatePurchased();
}

class _DialogConversionCenterStatePurchased extends State<DialogConversionCenterPurchased> {
  TextEditingController? _quantityToConvert;
  TextEditingController? _priceDecision;
  late String quantityValue;
  bool _loading = false;

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

  Future<void> _convertProduct() async {
    setState(() {
      _loading = true;
    });

    ProductPurchased product = widget.product;
    bool conversionSuccess = false;

    try {
      if (product is MilkBatchPurchased) {
        CheeseProducerInventoryService cheeseProducerInventoryService =
            CheeseProducerInventoryService();
        conversionSuccess = await cheeseProducerInventoryService.transformMilkBatch(
            widget.wallet, product.id, quantityValue, product.getQuantity().toString(), "DOP");
      } else if (product is CheeseBlockPurchased) {
        RetailerInventoryService retailerInventoryService =
            RetailerInventoryService();
        conversionSuccess = await retailerInventoryService.transformCheesePiece(
            widget.wallet, _priceDecision!.text, quantityValue, product.getExpirationDate());
      }
    } catch (error) {
      // Gestisci l'errore qui, mostra un alert dialog o esegui altre azioni necessarie
      print("Errore durante la conversione: $error");
      CustomPopUpDialog.showConversionError(context);
    } finally {
      // Assicurati che la barra di caricamento venga rimossa anche in caso di errore
      setState(() {
        _loading = false;
      });
    }

    if (conversionSuccess) {
      Navigator.of(context).pop();
      CustomPopUpDialog.showConversionSuccess(
          context, "La conversione è avvenuta con successo!");
    }
  }

  Widget _buildConvertButton() {
    return ElevatedButton(
      child: Text('Convert'),
      onPressed: _loading ? () {} : _convertProduct,
    );
  }

  Widget _buildTextForm() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Quantità da convertire:',
        labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      controller: _quantityToConvert,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  Widget _buildPriceForm() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Inserisci il prezzo del singolo CheesePiece :',
        labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      controller: _priceDecision,
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
          _loading
              ? CustomLoadingIndicator(progress: 0.5)
              : _buildConvertButton(),
        ],
      ),
    );
  }
}
