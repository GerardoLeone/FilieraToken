import 'package:filiera_token_front_end/utils/color_utils.dart';
import 'package:filiera_token_front_end/utils/enums.dart';
import 'package:flutter/material.dart';

class CustomInputValidator extends StatefulWidget {
  final TextInputType inputType;
  final String labelText;
  final Function(String)? onChanged;
  final TextEditingController controller; // Pass the controller as a parameter
  final InputDecoration decoration;

  const CustomInputValidator({
    Key? key,
    required this.inputType,
    required this.labelText,
    required this.controller, // Add the controller parameter
    this.onChanged,
    this.decoration = const InputDecoration(),
  }) : super(key: key);

  @override
  State<CustomInputValidator> createState() => _CustomInputValidatorState();
}

class _CustomInputValidatorState extends State<CustomInputValidator> {
  bool isValid = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: (widget.inputType == TextInputType.visiblePassword) ? true : false,
      controller: widget.controller, // Use the provided controller
      keyboardType: widget.inputType,
      decoration: widget.decoration.copyWith(
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: ColorUtils.labelColor, // Colore neutral
        ),
        errorText: _getErrorMessage(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: ColorUtils.labelColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: ColorUtils.labelColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
      ),
      onChanged: (value) {
        widget.onChanged?.call(value);
        setState(() {});
      },
    );
  }

  String? _getErrorMessage() {
    switch (widget.inputType) {
      case TextInputType.text:
        if (widget.controller.text.length < 8) {
          isValid = false;
          return 'Il testo deve essere lungo almeno 8 caratteri.';
        } else {
          isValid = true;
        }
        break;
      case TextInputType.emailAddress:
        if (!RegExp(r'^.+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$').hasMatch(widget.controller.text)) {
          isValid = false;
          return 'Inserisci un indirizzo email valido.';
        } else {
          isValid = true;
        }
        break;
      case TextInputType.visiblePassword:
        if (widget.controller.text.length < 8) {
          isValid = false;
          return 'La password deve essere lunga almeno 8 caratteri.';
        } else if (!RegExp(r'[A-Z]').hasMatch(widget.controller.text)) {
          isValid = false;
          return 'La password deve contenere almeno una lettera maiuscola.';
        } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_]').hasMatch(widget.controller.text)) {
          isValid = false;
          return 'La password deve contenere almeno un carattere speciale.';
        } else {
          isValid = true;
        }
        break;
      default:
        isValid = false;
    }
    return null;
  }
}
