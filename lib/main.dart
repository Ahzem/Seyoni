import 'package:flutter/material.dart';
import 'src/widgets/background_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: BackgroundWidget(
          child: Scaffold(
            backgroundColor:
                Colors.transparent, // Make Scaffold background transparent
            appBar: AppBar(
              backgroundColor:
                  Colors.transparent, // Make AppBar background transparent
              elevation: 0, // Remove AppBar shadow
              title: Image.asset(
                'assets/images/logo.png',
                height: 40,
                fit: BoxFit.cover,
              ),
              centerTitle: true,
            ),
            body: const Center(
              child: Text(
                'Hello World',
                style: TextStyle(color: Colors.white), // Example content
              ),
            ),
          ),
        ),
      ),
    );
  }
}
