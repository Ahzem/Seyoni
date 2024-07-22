import 'package:flutter/material.dart';
import 'package:seyoni/src/widgets/button.dart';
import '../widgets/background_widget.dart';
import '../constants/constants.dart';
import '../widgets/button.dart';

void main() {
  runApp(const InstructionPage3());
}

class InstructionPage3 extends StatelessWidget {
  const InstructionPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        body: BackgroundWidget(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/logo.png',
                height: 50,
                fit: BoxFit.cover,
              ),
              Container(margin: const EdgeInsets.only(bottom: 15)),
              Image.asset(
                'assets/images/technicians-3.png',
                height: 350,
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
                    Text(
                      'Effortless Convenience',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Find help effortlessly with Seyoni. Book, pay, and track providers in real-time, with emergency assistance for peace of mind.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kParagraphTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButtonOutlined(
                    text: 'Sign In',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Container(width: 15),
                  CustomButtonFilled(
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
