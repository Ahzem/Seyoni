// background_widget.dart
import 'dart:ui';
import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child;

  const BackgroundWidget({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Background image with blur effect
        Positioned.fill(
          child: Image.asset(
            'assets/images/background.png', // Replace with your background image path
            fit: BoxFit.cover, // Optional: Blends the overlay with the image
          ),
        ),
        // Apply blur filter
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 10, sigmaY: 10), // Adjust the blur intensity
            child: Container(
              color: Colors
                  .transparent, // Needs to be transparent to allow the blur effect
            ),
          ),
        ),
        // Your main content goes here
        Positioned.fill(
          child: Center(
            child: child,
          ),
        ),
      ],
    );
  }
}
