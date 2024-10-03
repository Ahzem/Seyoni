import 'package:flutter/material.dart';
import '../../pages/menu/components/menu_item.dart';
import 'dart:ui';

class MenuSignOut extends StatelessWidget {
  const MenuSignOut({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        const Opacity(
          opacity: 0.5, // Background opacity
          child: ModalBarrier(
            dismissible: true,
            color: Colors.black,
          ),
        ),
        Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255)
                      .withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MenuItem(
                      iconPath: 'assets/icons/menu/Logout.png',
                      text: 'Log Out',
                      onPressed: () {
                        // Add your onPressed logic here
                      },
                    ),
                    const SizedBox(height: 10),
                    MenuItem(
                      iconPath: 'assets/icons/menu/Settings.png',
                      text: 'Settings',
                      onPressed: () {
                        // Add your onPressed logic here
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
