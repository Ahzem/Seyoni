import 'package:flutter/material.dart';
import '../config/route.dart';
import './alertbox/menu.dart';
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
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 20.0, sigmaY: 20.0), // Apply blur effect
            child: Container(
              color: Colors.black.withOpacity(0.3),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'assets/icons/AppBar/notification-outlined.png',
                        height: 24,
                        width: 24,
                      ),
                      onPressed: () {
                        // Add notification page
                        Navigator.pushNamed(context, AppRoutes.notification);
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
                        // Add menu page
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return MenuSignOut();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
