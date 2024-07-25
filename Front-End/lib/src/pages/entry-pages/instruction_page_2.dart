import 'package:flutter/material.dart';
import '../../widgets/background_widget.dart';
import 'instruction_page_3.dart';
import '../../constants/constants_color.dart';
import 'components/instructions_.dart';
import '../../config/route.dart';

void main() {
  runApp(const instructionPage2());
}

class instructionPage2 extends StatelessWidget {
  const instructionPage2({super.key});

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
                'assets/images/technicians-2.png',
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
                    instructionTitle2,
                    SizedBox(height: 5),
                    instructionBody2,
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.instruction3);
                    },
                    backgroundColor: kPrimaryColor,
                    child: const Icon(Icons.arrow_forward),
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
