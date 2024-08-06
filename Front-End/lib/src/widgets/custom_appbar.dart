import 'package:flutter/material.dart';
import '../config/route.dart';
import 'dart:ui';
import '../constants/constants_color.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  Size preferredSize = const Size.fromHeight(60.0);
  final Function(int) onTap;
  CustomAppBar({super.key, required this.onTap});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _isNotificationFilled = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: kTransparentColor,
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 10.0, sigmaY: 10.0), // Apply blur effect
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Image.asset(
                      _isNotificationFilled
                          ? 'assets/icons/AppBar/notification-filled.png'
                          : 'assets/icons/AppBar/notification-outlined.png',
                      height: 24,
                      width: 24,
                    ),
                    onPressed: () async {
                      setState(() {
                        _isNotificationFilled = !_isNotificationFilled;
                      });
                      widget.onTap(0); // Call the onTap function with index 0
                      setState(() {
                        _isNotificationFilled = !_isNotificationFilled;
                      });
                    },
                  ),
                  const Image(
                    image: AssetImage('assets/images/logo.png'),
                    height: 35,
                    fit: BoxFit.cover,
                  ),
                  IconButton(
                    icon: Image.asset(
                      'assets/icons/AppBar/menu.png',
                      height: 24,
                      width: 24,
                    ),
                    onPressed: () {
                      widget.onTap(1); // Call the onTap function with index 1
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
