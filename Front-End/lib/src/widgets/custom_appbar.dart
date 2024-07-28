import 'package:flutter/material.dart';
import '../constants/constants_color.dart';
import '../widgets/background_widget.dart';

// custom app bar for home pages

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTransparentColor,
      body: BackgroundWidget(
        child: SafeArea(
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
                  height: 30,
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
    );
  }
}


// custom app bar for entry pages
