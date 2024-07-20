import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const LandingApp());
}

class LandingApp extends StatelessWidget {
  const LandingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            // Background image with blur effect
            Positioned.fill(
              child: Image.asset(
                'assets/images/background.png', // Replace with your background image path
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(
                    0.2), // Optional: Adds a dark overlay to the image
                colorBlendMode: BlendMode
                    .darken, // Optional: Blends the overlay with the image
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
            // Your main content goes here, e.g., Center widget with Text
            const Scaffold(
              backgroundColor:
                  Colors.transparent, // Make Scaffold background transparent
              body: Center(
                child: Text(
                  'Hello World',
                  style: TextStyle(color: Colors.white), // Example content
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
