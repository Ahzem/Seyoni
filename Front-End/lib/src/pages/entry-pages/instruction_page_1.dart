import 'package:flutter/material.dart';
import '../../widgets/background_widget.dart';
import 'instruction_page_2.dart';
import '../../constants/constants-color.dart';
import '../../constants/constants-font.dart';

void main() {
  runApp(const InstructionPage1());
}

class InstructionPage1 extends StatelessWidget {
  const InstructionPage1({super.key});

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
                'assets/images/technicians-1.png',
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
                    Text(
                      'Welcome to Seyoni!',
                      style: kSubtitleTextStyle,
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Easily connect with reliable service providers for home repairs, cleaning, and more. Just a few taps and help is on the way!',
                      textAlign: TextAlign.center,
                      style: kBodyTextStyle,
                    ),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InstructionPage2()),
                      );
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
