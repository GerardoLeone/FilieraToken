import 'package:flutter/material.dart';
import 'package:filiera_token_front_end/utils/enums.dart';
import 'package:filiera_token_front_end/utils/color_utils.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final CustomType type;
  final VoidCallback onPressed;

  CustomButton({
    this.text = "",
    required this.type,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorUtils.getColor(type),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Arrotonda i bordi
        ),
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20), // Spazio interno
        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Testo più grande e bold
        foregroundColor: Colors.white
      ),
      child: Text(text.isEmpty ? Enums.getDefaultText(type) : text),
    );
  }
}
