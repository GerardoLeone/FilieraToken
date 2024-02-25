import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomMenu extends StatefulWidget {
  const CustomMenu({super.key});

  @override
  State<CustomMenu> createState() => _MenuState();
}

class _MenuState extends State<CustomMenu> with SingleTickerProviderStateMixin {
  static const _menuTitles = [
    'Product Buyed', // Product Buyed
    'Inventory',// Inventory
    'History', // Transaction or Event of this User 
    'Logout', // Logout Routing 
    'Shop' // Go to Shop routing 
  ];

  static const _initialDelayTime = Duration(milliseconds: 50);
  static const _itemSlideTime = Duration(milliseconds: 250);
  static const _staggerTime = Duration(milliseconds: 50);
  static const _buttonDelayTime = Duration(milliseconds: 150);
  static const _buttonTime = Duration(milliseconds: 500);
  final _animationDuration = _initialDelayTime +
      (_staggerTime * _menuTitles.length) +
      _buttonDelayTime +
      _buttonTime;

  late AnimationController _staggeredController;
  final List<Interval> _itemSlideIntervals = [];

  @override
  void initState() {
    super.initState();

    _createAnimationIntervals();

    _staggeredController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..forward();
  }

  void _createAnimationIntervals() {
    for (var i = 0; i < _menuTitles.length; ++i) {
      final startTime = _initialDelayTime + (_staggerTime * i);
      final endTime = startTime + _itemSlideTime;
      _itemSlideIntervals.add(
        Interval(
          startTime.inMilliseconds / _animationDuration.inMilliseconds,
          endTime.inMilliseconds / _animationDuration.inMilliseconds,
        ),
      );
    }

  }

  @override
  void dispose() {
    _staggeredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildFlutterLogo(),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildFlutterLogo() {
    return const Positioned(
      right: -100,
      bottom: -30,
      child: Opacity(
        opacity: 0.2,
        child: FlutterLogo(
          size: 400,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ..._buildListItems(),
        const Spacer(),
      ],
    );
  }

  List<Widget> _buildListItems() {
    final listItems = <Widget>[];
    for (var i = 0; i < _menuTitles.length; ++i) {
      listItems.add(
        AnimatedBuilder(
          animation: _staggeredController,
          builder: (context, child) {
            final animationPercent = Curves.easeOut.transform(
              _itemSlideIntervals[i].transform(_staggeredController.value),
            );
            final opacity = animationPercent;
            final slideDistance = (1.0 - animationPercent) * 150;

            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(slideDistance, 0),
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                if(_menuTitles[i].compareTo('Logout')==0){
                  // Logout Routing 
                  context.go('/');

                }else if(_menuTitles[i].compareTo('Product Buyed')==0){
                  // Product Buyed Routing 
                  context.go('/home-page-user/profile/product-buyed');

                }else if(_menuTitles[i].compareTo('History')==0){
                  // History
                  context.go('/home-page-user/profile/history');

                }else if(_menuTitles[i].compareTo('Shop')==0){
                  // Go to shop home 
                  context.go('/home-page-user');
                }else if(_menuTitles[i].compareTo('Inventory')==0){
                  // Inventory Routing 
                  context.go('/home-page-user/profile/inventory');
                }
                },
              child: 
              Text(
                _menuTitles[i],
                 textAlign: TextAlign.left,
                  style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  )
                  ),
                ),
              ),
            ),
          );
      }
    return listItems;
  }
}