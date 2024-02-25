import 'package:filiera_token_front_end/components/organisms/user_environment/components/dialog_purchase_center.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/components/dialog_purchase_right.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/product_buy_profile/components/dialog_conversion_center.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/product_buy_profile/components/dialog_conversion_right.dart';
import 'package:filiera_token_front_end/models/Product.dart';
import 'package:filiera_token_front_end/utils/enums.dart';
import 'package:flutter/material.dart';

class DialogProductDetails extends StatelessWidget {
  final Product product;
  final DialogType dialogType; // Nuovo parametro

  DialogProductDetails({
    required this.product,
    required this.dialogType,
  });

  static void show(BuildContext context, Product product, DialogType dialogType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogProductDetails(product: product, dialogType: dialogType);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 624.0,
        height: 350.0,
        margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Colonna di sinistra
            Container(
              width: 200.0,
              margin: EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: AssetImage(Enums.getAssetPath(product.getAsset())),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Back'),
                    ),
                  ),
                ],
              ),
            ),
            // Spazio tra le colonne
            SizedBox(width: 8.0),
            // Colonna centrale
            Container(
              width: 200.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoTile('ID', ' ${product.id}'),
                  if (product.getExpirationDate().isNotEmpty)
                    InfoTile('Scadenza', ' ${product.getExpirationDate()}'),
                  InfoTile('Quantità disponibile', ' ${product.getQuantity()}'),
                  InfoTile('Prezzo', ' \$${product.getUnitPrice()}'),
                  Spacer(),
                  if(dialogType == DialogType.DialogConversion)
                    DialogConversionCenter(product: product)
                  else if(dialogType == DialogType.DialogPurchase)
                    DialogPurchaseCenter(product: product)
                ],
              ),
            ),
            // Spazio tra le colonne
            SizedBox(width: 8.0),
            // Colonna destra
            Container(
              width: 200.0,
              child: (dialogType == DialogType.DialogConversion)
                  ? DialogConversionRight()
                  : DialogPurchaseRight(), // Puoi fornire un widget vuoto o un altro widget di fallback
            )

          ],
        ),
      ),
    );
  }
}

//Crea un div per ogni info
class InfoTile extends StatelessWidget {
  final String label;
  final String value;

  InfoTile(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.blue,
      ),
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.white, // Imposta il colore del testo a bianco
              ),
              children: [
                TextSpan(
                  text: '$label ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: value,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

