import 'package:filiera_token_front_end/components/atoms/custom_button.dart';
import 'package:filiera_token_front_end/components/molecules/custom_loading_bar.dart';
import 'package:filiera_token_front_end/utils/enums.dart';
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
            widget.wallet, product.id, quantityValue, product.price.toString());
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
    return CustomButton(
      text: "Convert", 
      type: CustomType.neutralShade, 
      onPressed: _loading ? () {} : _convertProduct);
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
  bool _loading = false;

  @override
  void initState() {
    _quantityToConvert = TextEditingController();
    _priceDecision = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _quantityToConvert?.dispose();
    _priceDecision?.dispose();
    super.dispose();
  }

  Future<void> _convertProduct() async {
    setState(() {
      _loading = true;
    });

    ProductPurchased product = widget.product;
    bool conversionSuccess = false;

    print("Metodo di conversione prima del try");

    try {
      if (product is MilkBatchPurchased) {
        CheeseProducerInventoryService cheeseProducerInventoryService =
            CheeseProducerInventoryService();
            print("Sono nel metodo di conversione (dentro il try)");
        print(widget.wallet);
        print(product.id);
        print(_quantityToConvert!.text);
        print(_priceDecision!.text);
        conversionSuccess = await cheeseProducerInventoryService.transformMilkBatch(
            widget.wallet, product.id, _quantityToConvert!.text, _priceDecision!.text, "DOP");
      } else if (product is CheeseBlockPurchased) {
        RetailerInventoryService retailerInventoryService =
            RetailerInventoryService();
        conversionSuccess = await retailerInventoryService.transformCheesePiece(
            widget.wallet, product.id, _quantityToConvert!.text, _priceDecision!.text);
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
    return CustomButton(
      text: "Convert", 
      type: CustomType.neutralShade, 
      onPressed: _loading ? () {} : _convertProduct);
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
          _buildPriceForm(),
          SizedBox(height: 30),
          _loading
              ? CustomLoadingIndicator(progress: 0.5)
              : _buildConvertButton(),
        ],
      ),
    );
  }
}
