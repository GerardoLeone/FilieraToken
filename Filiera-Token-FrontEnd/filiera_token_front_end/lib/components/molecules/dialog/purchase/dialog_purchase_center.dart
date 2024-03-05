import 'package:filiera_token_front_end/components/atoms/custom_button.dart';
import 'package:filiera_token_front_end/components/molecules/dialog/custom_alert_dialog.dart';
import 'package:filiera_token_front_end/components/organisms/user_environment/services/transaction_service.dart';
import 'package:filiera_token_front_end/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:filiera_token_front_end/models/Product.dart';

class DialogPurchaseCenter extends StatefulWidget {
  final Product product;
  final String userType;
  final String buyer;

  DialogPurchaseCenter({
    required this.product, 
    required this.userType,
    required this.buyer
  });

  @override
  _DialogPurchaseCenterState createState() => _DialogPurchaseCenterState();
}

class _DialogPurchaseCenterState extends State<DialogPurchaseCenter> {



  TransactionService transactionService = TransactionService();
  



  TextEditingController ?_quantityToBuy;

  @override
  void dispose() {
    _quantityToBuy?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _quantityToBuy = TextEditingController();
    super.initState();
  }

  
  Widget _buildBuyButton() {
    return CustomButton(
        text: "Buy", 
        type: CustomType.neutralShade, 
        onPressed: () async {
        Product productToBuy = widget.product;
        // BuyLogic 
        switch (widget.userType) {
          case "Consumer": {
              // Converto e calcolo il prezzo totale 
            String quantityToBuy = _quantityToBuy!.text;
            print("Sono nel metodo di acquisto!");
            int totalPrice = int.parse(quantityToBuy) * int.parse(productToBuy.getUnitPrice().toString());
            print("Prezzo totale: " + totalPrice.toString());
            String priceToPay = totalPrice.toString();

            print("Product Seller : " + productToBuy.seller);
            print("Product buyer:" + widget!.buyer);

            // Verifica se la quantità desiderata è disponibile
            if (int.parse(quantityToBuy) <= productToBuy.getQuantity()) {
              try {
                bool success = await transactionService.buyCheesePieceProduct(
                  productToBuy.id,
                  quantityToBuy,
                  widget.buyer,
                  productToBuy.seller,
                  priceToPay,
                );

                if (success) {
                  // Mostra la transazione di successo
                  CustomPopUpDialog.showBuyCheesePieceSuccess(context, "Transazione avvenuta con successo!");
                } else {
                  CustomPopUpDialog.showBuyCheesePieceError(context);
                }
              } catch (error) {
                // Gestione degli errori, se necessario
                print("Errore durante l'acquisto: $error");
                CustomPopUpDialog.showBuyCheesePieceError(context);
              }
            } else {
              // Mostra un messaggio che la quantità desiderata non è disponibile
              CustomPopUpDialog.showBuyCheesePieceErrorMsg(context, "Transazione Errata! Quantità richiesta non disponibile.");
            }

            break;

          }
          case "CheeseProducer": {
            // Converto e calcolo il prezzo totale 
            String quantityToBuy = _quantityToBuy!.text;
            print("Sono nel metodo di acquisto!");
            int totalPrice = int.parse(quantityToBuy) * int.parse(productToBuy.getUnitPrice().toString());
            print("Prezzo totale: " + totalPrice.toString());
            String priceToPay = totalPrice.toString();

            print("Product Seller : " + productToBuy.seller);
            print("Product buyer:" + widget!.buyer);

            // Verifica se la quantità desiderata è disponibile
            if (int.parse(quantityToBuy) <= productToBuy.getQuantity()) {
              try {
                bool success = await transactionService.buyMilkBatchProduct(
                  productToBuy.id,
                  quantityToBuy,
                  widget.buyer,
                  productToBuy.seller,
                  priceToPay,
                );

                if (success) {
                  // Mostra la transazione di successo
                  CustomPopUpDialog.showBuyMilkBatchSuccess(context, "Transazione avvenuta con successo!");
                } else {
                  CustomPopUpDialog.showBuyMilkBatchError(context);
                }
              } catch (error) {
                // Gestione degli errori, se necessario
                print("Errore durante l'acquisto: $error");
                CustomPopUpDialog.showBuyMilkBatchError(context);
              }
            } else {
              // Mostra un messaggio che la quantità desiderata non è disponibile
              CustomPopUpDialog.showBuyMilkBatchErrorMsg(context, "Transazione Errata! Quantità richiesta non disponibile.");
            }

            break;
          }
          case "Retailer": {
            String quantityToBuy = _quantityToBuy!.text;
            print("Sono nel metodo di acquisto del Retailer!");
            int totalPrice = int.parse(quantityToBuy) * int.parse(productToBuy.getUnitPrice().toString());
            print("Prezzo totale: " + totalPrice.toString());
            String priceToPay = totalPrice.toString();

            print("Product Seller : " + productToBuy.seller);
            print("Product buyer:" + widget!.buyer);

            // Verifica se la quantità desiderata è disponibile
            if (int.parse(quantityToBuy) <= productToBuy.getQuantity()) {
              try {
                bool success = await transactionService.buyCheeseBlockProduct(
                  productToBuy.id,
                  quantityToBuy,
                  widget.buyer,
                  productToBuy.seller,
                  priceToPay,
                );

                if (success) {
                  // Mostra la transazione di successo
                  CustomPopUpDialog.showBuyCheeseBlockSuccess(context, "Transazione avvenuta con successo!");
                } else {
                  CustomPopUpDialog.showBuyCheeseBlockError(context);
                }
              } catch (error) {
                // Gestione degli errori, se necessario
                print("Errore durante l'acquisto: $error");
                CustomPopUpDialog.showBuyCheeseBlockError(context);
              }
            } else {
              // Mostra un messaggio che la quantità desiderata non è disponibile
              CustomPopUpDialog.showBuyCheeseBlockErrorMsg(context, "Transazione Errata! Quantità richiesta non disponibile.");
            }
            
          }
        }
      }
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
