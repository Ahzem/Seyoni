import 'package:flutter/material.dart';
import 'dart:async';
import '../../widgets/background_widget.dart';
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
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const InstructionPage1()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BackgroundWidget(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/logo-icon.png',
                height: height * 0.25,
                fit: BoxFit.cover,
              ),
              Image.asset(
                'assets/images/logo-name.png',
                height: height * 0.15,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
