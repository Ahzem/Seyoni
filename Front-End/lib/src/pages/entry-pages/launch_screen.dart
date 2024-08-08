import 'dart:async';
import 'package:flutter/material.dart';
import 'package:seyoni/src/constants/constants_color.dart';
import '../../widgets/background_widget.dart';
import '../../config/route.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  LaunchScreenState createState() => LaunchScreenState();
}

class LaunchScreenState extends State<LaunchScreen> {
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      setState(() {
        _opacity = 0.0;
      });
      Timer(const Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, AppRoutes.instruction);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kTransparentColor,
      body: BackgroundWidget(
        child: Center(
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(seconds: 1),
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
      ),
    );
  }
}
