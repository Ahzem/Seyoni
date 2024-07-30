import 'package:flutter/material.dart';
import 'dart:ui';
import '../constants/constants_color.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const CustomAppBar({super.key}) : preferredSize = const Size.fromHeight(60.0);

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
                    icon: const Icon(Icons.notifications_none_outlined,
                        size: 24, color: kPrimaryColor),
                    onPressed: () {},
                  ),
                  const Image(
                    image: AssetImage('assets/images/logo.png'),
                    height: 35,
                    fit: BoxFit.cover,
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu_outlined,
                        size: 24, color: kPrimaryColor),
                    onPressed: () {},
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
