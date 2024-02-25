import 'package:flutter/material.dart';
import 'package:filiera_token_front_end/utils/enums.dart';

class ColorUtils {

  /*
   *  Questa funzione restituire un colore basandosi sul CustomType
   */
  static Color getColor(CustomType type) {
      switch (type) {
        case CustomType.neutral:
          return Colors.blue;
        case CustomType.danger:
          return Colors.red;
        case CustomType.warning:
          return Colors.amber;
        case CustomType.success:
          return Colors.green;
      }
    }
}