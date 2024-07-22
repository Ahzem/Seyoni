import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/background_widget.dart';
import 'instruction_page_1.dart'; // Make sure to import your instruction page

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 3 seconds before navigating to the instruction page
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const InstructionPage1()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BackgroundWidget(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/logo-icon.png',
                height: 150,
                fit: BoxFit.cover,
              ),
              Image.asset(
                'assets/images/logo-name.png',
                height: 120,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
