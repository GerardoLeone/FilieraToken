import 'package:flutter/material.dart';
import 'package:filiera_token_front_end/utils/color_utils.dart';
import 'package:filiera_token_front_end/utils/enums.dart';

class CustomDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final void Function(T?) onChanged;

  CustomDropdown({
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  _CustomDropdownState<T> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  late T selectedValue;
  CustomType type = CustomType.neutral;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value ?? widget.items.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.grey[200], // Grigio di sfondo
        border: Border.all(color: ColorUtils.getColor(type)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: DropdownButton<T>(
        value: selectedValue,
        onChanged: (value) {
          setState(() {
            selectedValue = value!;
          });
          widget.onChanged(value);
        },
        underline: Container(),
        icon: Icon(Icons.arrow_drop_down, color: ColorUtils.getColor(type)),
        items: widget.items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              item.toString(),
              style: TextStyle(
                color: ColorUtils.getColor(type),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
