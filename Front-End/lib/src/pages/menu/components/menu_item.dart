import 'dart:ui';

import 'package:flutter/material.dart';
import '../../../constants/constants_color.dart';
import '../../../constants/constants_font.dart';

class MenuItem extends StatefulWidget {
  final String iconPath;
  final String text;
  final VoidCallback onPressed;

  const MenuItem({
    required this.iconPath,
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  MenuItemState createState() => MenuItemState();
}

class MenuItemState extends State<MenuItem> {
  bool _isPressed = false;

  void _handlePress() {
    setState(() {
      _isPressed = !_isPressed;
    });
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handlePress,
      child: Stack(
        children: [
          // Apply blur effect to the background
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                color: Colors
                    .transparent, // This is needed to apply the blur effect
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _isPressed
                  ? kPrimaryColor.withOpacity(0.2)
                  : const Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Image.asset(
                        widget.iconPath,
                        height: 30,
                        width: 30,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.text,
                      style: kMenuItemTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  color: kBackgroundColor,
                  onPressed: _handlePress,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
