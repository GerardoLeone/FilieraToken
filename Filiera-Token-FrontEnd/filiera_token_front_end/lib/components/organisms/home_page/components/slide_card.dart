import 'package:flutter/material.dart';

class SlideInCard extends StatefulWidget {
  final String title;
  final String description;
  final Offset beginOffset;
  final Offset endOffset;

  SlideInCard({
    required this.title,
    required this.description,
    required this.beginOffset,
    required this.endOffset
  });

  @override
  _SlideInCardState createState() => _SlideInCardState();
}




class _SlideInCardState extends State<SlideInCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset(1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: _offsetAnimation.value,
            child: Card(
              elevation: _isHovered ? 8.0 : 4.0, // Aumenta l'ombra al passaggio del mouse
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Bordi arrotondati
                side: BorderSide(color: Colors.grey[200]!, width: 1.0), // Aggiunge un bordo
              ),
              child: InkWell(
                onTap: () {
                  // Azione da eseguire quando la card viene premuta
                },
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        widget.description,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
              color: _isHovered ? Colors.blue[50] : Colors.white, // Cambia il colore della card se il mouse è sopra
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}