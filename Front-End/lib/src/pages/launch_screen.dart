import 'package:flutter/material.dart';
import '../widgets/background_widget.dart';

void main() {
  runApp(const LaunchScreen());
}

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

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
