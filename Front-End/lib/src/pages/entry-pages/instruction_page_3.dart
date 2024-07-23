import 'package:flutter/material.dart';
import '../../widgets/background_widget.dart';
import '../../constants/constants-color.dart';
import 'components/instructions-data.dart';
import '../../widgets/custom-button.dart';

void main() {
  runApp(const InstructionPage3());
}

class InstructionPage3 extends StatelessWidget {
  const InstructionPage3({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
                    InstructionTitle3,
                    SizedBox(height: 5),
                    InstructionBody3,
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
                      Navigator.pop(context);
                    },
                  ),
                  Container(width: 15),
                  PrimaryFilledButton(
                    text: 'Sign Up',
                    onPressed: () {
                      Navigator.pop(context);
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
