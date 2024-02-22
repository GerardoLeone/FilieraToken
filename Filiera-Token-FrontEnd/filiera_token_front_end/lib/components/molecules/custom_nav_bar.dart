import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final bool centerTitle;
  final double elevation;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.centerTitle = true,
    this.elevation = 0.0, 
    required bool automaticallyImplyLeading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: TextStyle(color: Colors.black)),
      centerTitle: centerTitle,
      leading: leading,
      actions: actions,
      backgroundColor: backgroundColor,
      elevation: elevation,
    );
  }

  static buildSimpleNavBar(){
    return CustomAppBar(
            title: 'FilieraToken-Shop',
            leading: Image.asset('../assets/favicon.png'),
            automaticallyImplyLeading: false,
      );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
