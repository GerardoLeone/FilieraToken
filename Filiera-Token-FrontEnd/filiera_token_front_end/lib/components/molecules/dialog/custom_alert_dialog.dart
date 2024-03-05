import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomPopUpDialog  {

  /// --------------------------------------------------------------------- Registration Dialog ----------------------------------------------------------------------

  void showSuccessPopupRegistration(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Registrazione avvenuta con successo!'),
        content: Text("Grazie per esserti registrato! Ora puoi accedere all'app"),
        actions: [
          TextButton(
            onPressed: () {
              context.go('/signin');
              // Invia l'utente alla pagina di login
            },
            child: Text('OK'),
          ),
        ],

        backgroundColor: Colors.green[50], // Colore verde
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        contentTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 16.0),
        elevation: 4.0,
        icon: Icon(
          Icons.done,
          color: Colors.green,
          size: 32.0,
        ),
      );
    },
  ).then((value) {
      // Questo blocco di codice verrà eseguito dopo la chiusura dell'AlertDialog
      context.go('/signin');
    });
  }
  
  void  showErrorPopupRegistration(BuildContext context, String error) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Registrazione non completata'),
        content: Text(error),
        actions: [
        ],
        backgroundColor: Colors.red[50], // Colore rosso
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        contentTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 16.0),
        elevation: 4.0,
        icon: Icon(
          Icons.dangerous,
          color: Colors.red,
          size: 32.0 ),
          );
    },
  );
  }
  
  /// --------------------------------------------------------------------- Login Dialog ----------------------------------------------------------------------


  void showSuccessPopupLogin(BuildContext context, String path) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Login avvenuto con successo!'),
        content: Text("Premi Ok per essere indirizzato nell'area utente"),
        actions: [
          TextButton(
            onPressed: () {
              context.go(path);
              // Invia l'utente alla pagina di homepageuser
            },
            child: Text('OK'),
          ),
        ],

        backgroundColor: Colors.green[50], // Colore verde
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        contentTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 16.0),
        elevation: 4.0,
        icon: Icon(
          Icons.done,
          color: Colors.green,
          size: 32.0,
        ),
      );
    },
  ).then((value) {
      // Questo blocco di codice verrà eseguito dopo la chiusura dell'AlertDialog
      context.go(path);
    });
  }
  
  void  showErrorPopupLogin(BuildContext context, String error) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Login non completata'),
        content: Text(error),
        actions: [
        ],
        backgroundColor: Colors.red[50], // Colore rosso
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        contentTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 16.0),
        elevation: 4.0,
        icon: Icon(
          Icons.dangerous,
          color: Colors.red,
          size: 32.0 ),
          );
    },
  );
  }


  /// --------------------------------------------------------------------- CheeseBlock Dialog ----------------------------------------------------------------------


  static void  showMilkBatchAddSuccess(BuildContext context, String msg) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Aggiunta Partita di Latte'),
        content: Text(msg),
        actions: [
        ],
        backgroundColor: Colors.red[50], // Colore rosso
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        contentTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 16.0),
        elevation: 4.0,
        icon: Icon(
          Icons.check,
          color: Colors.green,
          size: 32.0 ),
          );
    },
  );
  }

  static void showMilkBatchAddError(BuildContext context){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Errore Aggiunta'),
          content: Text("Problemi con l'aggiunta della partita di latte."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
          backgroundColor: Colors.red[50], // Colore rosso
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          contentTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
          ),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: 16.0),
          elevation: 4.0,
          icon: Icon(
            Icons.error,
            color: Colors.red,
            size: 32.0,
          ),
        );
      },
    );
  }


  /// --------------------------------------------------------------------- CheeseBlock Dialog ----------------------------------------------------------------------

  static void showCheeseBlockAddSuccess(BuildContext context){
    /// TODO : Success adding CheeseBlock 
  
  }

  static void showCheeseBlockAddError(BuildContext context){
    /// TODO : Error adding CheeseBlock 
  }


  /// --------------------------------------------------------------------- Conversion Action ---------------------------------------------------------------------------------
  
  static void  showConversionSuccess(BuildContext context, String msg) {
      showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Stato Conversione'),
          content: Text(msg),
          actions: [
          ],
          backgroundColor: Colors.red[50], // Colore rosso
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          contentTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
          ),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: 16.0),
          elevation: 4.0,
          icon: Icon(
            Icons.check,
            color: Colors.green,
            size: 32.0 ),
            );
      },
    );
  }

  static void showConversionError(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Errore Conversione'),
          content: Text('Problemi con la conversione.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
          backgroundColor: Colors.red[50], // Colore rosso
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          contentTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
          ),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: 16.0),
          elevation: 4.0,
          icon: Icon(
            Icons.error,
            color: Colors.red,
            size: 32.0,
          ),
        );
      },
    );
  } 


// -------------------------------------------------------------------------------------------- Buy Logic -------------------------------------------------------------------------------------

  static void  showBuyMilkBatchSuccess(BuildContext context, String msg) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Aggiunta Partita di Latte'),
        content: Text(msg),
        actions: [
        ],
        backgroundColor: Colors.red[50], // Colore rosso
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        contentTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 16.0),
        elevation: 4.0,
        icon: Icon(
          Icons.check,
          color: Colors.green,
          size: 32.0 ),
          );
    },
  );
  }

  static void showBuyMilkBatchError(BuildContext context){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Transazione Errata'),
          content: Text("Transazione non effettuata!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
          backgroundColor: Colors.red[50], // Colore rosso
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          contentTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
          ),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: 16.0),
          elevation: 4.0,
          icon: Icon(
            Icons.error,
            color: Colors.red,
            size: 32.0,
          ),
        );
      },
    );
  }  

  static void showBuyMilkBatchErrorMsg(BuildContext context, String msg){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Transazione Errata'),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
          backgroundColor: Colors.red[50], // Colore rosso
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          contentTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
          ),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: 16.0),
          elevation: 4.0,
          icon: Icon(
            Icons.error,
            color: Colors.red,
            size: 32.0,
          ),
        );
      },
    );
  }  

  static void  showBuyCheeseBlockSuccess(BuildContext context, String msg) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Aggiunto Blocco di Formaggio'),
        content: Text(msg),
        actions: [
        ],
        backgroundColor: Colors.red[50], // Colore rosso
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        contentTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 16.0),
        elevation: 4.0,
        icon: Icon(
          Icons.check,
          color: Colors.green,
          size: 32.0 ),
          );
    },
  );
  }

  static void showBuyCheeseBlockError(BuildContext context){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Transazione Errata'),
          content: Text("Transazione non effettuata!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
          backgroundColor: Colors.red[50], // Colore rosso
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          contentTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
          ),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: 16.0),
          elevation: 4.0,
          icon: Icon(
            Icons.error,
            color: Colors.red,
            size: 32.0,
          ),
        );
      },
    );
  }  

  static void showBuyCheeseBlockErrorMsg(BuildContext context, String msg){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Transazione Errata'),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
          backgroundColor: Colors.red[50], // Colore rosso
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          contentTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
          ),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: 16.0),
          elevation: 4.0,
          icon: Icon(
            Icons.error,
            color: Colors.red,
            size: 32.0,
          ),
        );
      },
    );
  }  

  

}