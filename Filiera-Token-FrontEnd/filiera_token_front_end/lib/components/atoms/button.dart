import 'package:flutter/material.dart';

enum ButtonType { neutral, danger, warning, success }

class CustomButton extends StatelessWidget {
  final String text;
  final ButtonType type;
  final VoidCallback onPressed;

  CustomButton({
    this.text = "",
    required this.type,
    required this.onPressed,
  });

  Color _getButtonColor() {
    switch (type) {
      case ButtonType.neutral:
        return Colors.blue;
      case ButtonType.danger:
        return Colors.red;
      case ButtonType.warning:
        return Colors.amber;
      case ButtonType.success:
        return Colors.green;
    }
  }

  String _getDefaultText() {
    switch (type) {
      case ButtonType.neutral:
        return "Conferma";
      case ButtonType.danger:
        return "Cancella";
      case ButtonType.warning:
        return "Annulla";
      case ButtonType.success:
        return "OK";
    }
  }

  Color _getButtonTextColor() {
    switch (type) {
      case ButtonType.neutral:
        return Colors.blue;
      case ButtonType.danger:
        return Colors.red;
      case ButtonType.warning:
        return Colors.amber;
      case ButtonType.success:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _getButtonColor(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Arrotonda i bordi
        ),
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20), // Spazio interno
        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Testo più grande e bold
        foregroundColor: Colors.white
      ),
      child: Text(text.isEmpty ? _getDefaultText() : text),
    );
  }
}
