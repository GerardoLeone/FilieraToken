import 'package:flutter/material.dart';

class CustomInputValidator extends StatefulWidget {
  final TextInputType inputType;
  final String labelText;
  final Function(String) onChanged;
  final InputDecoration decoration;

  const CustomInputValidator({
    super.key,
    required this.inputType,
    required this.labelText,
    required this.onChanged,
    this.decoration = const InputDecoration(),
  });

  @override
  State<CustomInputValidator> createState() => _CustomInputValidatorState();
}

class _CustomInputValidatorState extends State<CustomInputValidator> {
  final TextEditingController _controller = TextEditingController();
  bool isValid = false; 

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: widget.inputType,
      decoration: widget.decoration.copyWith(
        labelText: widget.labelText,
        errorText: _getErrorMessage(),
      ),
      onChanged: (value) {
        widget.onChanged(value);
        setState(() {});
      },
    );
  }

  String? _getErrorMessage() {
    switch (widget.inputType) {
      case TextInputType.text:
        if (_controller.text.length < 8) {
          isValid = false;
          return 'Il testo deve essere lungo almeno 8 caratteri.';
        }else{
          isValid = true;
        }
        break;
      case TextInputType.emailAddress:
        if (!RegExp(r'^.+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$').hasMatch(_controller.text)) {
          isValid = false;
          return 'Inserisci un indirizzo email valido.';
        }else{
          isValid = true;
        }
        break;
      case TextInputType.visiblePassword:
        if (_controller.text.length < 8) {
          isValid = false;
          return 'La password deve essere lunga almeno 8 caratteri.';
        } else if (!RegExp(r'[A-Z]').hasMatch(_controller.text)) {
          isValid = false;
          return 'La password deve contenere almeno una lettera maiuscola.';
        } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(_controller.text)) {
          isValid = false;
          return 'La password deve contenere almeno un carattere speciale.';
        }else{
          isValid = true;
        }
        break;
      default: 
      isValid = false;
    }
    return null;
  }
}
