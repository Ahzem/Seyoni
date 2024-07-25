import 'package:flutter/material.dart';
import '../../widgets/background_widget.dart';
import '../../constants/constants_color.dart';
import 'components/instructions_.dart';
import '../../widgets/custom_button.dart';
import '../../config/route.dart';

void main() {
  runApp(const instructionPage3());
}

class instructionPage3 extends StatelessWidget {
  const instructionPage3({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        body: BackgroundWidget(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/logo.png',
                height: height * 0.08,
                fit: BoxFit.cover,
              ),
              Container(margin: const EdgeInsets.only(bottom: 15)),
              Image.asset(
                'assets/images/technicians-3.png',
                height: height * 0.5,
                fit: BoxFit.cover,
              ),
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kContainerColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: kBoarderColor,
                    width: 1.5,
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    instructionTitle3,
                    SizedBox(height: 5),
                    instructionBody3,
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PrimaryOutlinedButton(
                    text: 'Sign In',
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.signIn);
                    },
                  ),
                  Container(width: 15),
                  PrimaryFilledButton(
                    text: 'Sign Up',
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
