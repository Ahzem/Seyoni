import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/background_widget.dart';
import '../../constants/constants_color.dart';
import 'components/instructions_data.dart';
import '../../config/route.dart';

void main() {
  runApp(const InstructionApp());
}

class InstructionApp extends StatelessWidget {
  const InstructionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InstructionPage(),
    );
  }
}

class InstructionPage extends StatefulWidget {
  const InstructionPage({super.key});

  @override
  _InstructionPageState createState() => _InstructionPageState();
}

class _InstructionPageState extends State<InstructionPage> {
  int _currentPage = 0;

  final List<String> _images = [
    'assets/images/technicians-1.png',
    'assets/images/technicians-2.png',
    'assets/images/technicians-3.png',
  ];

  final List<Widget> _titles = [
    instructionTitle1,
    instructionTitle2,
    instructionTitle3,
  ];

  final List<Widget> _bodies = [
    instructionBody1,
    instructionBody2,
    instructionBody3,
  ];

  void _nextPage() {
    setState(() {
      if (_currentPage < _images.length - 1) {
        _currentPage++;
      } else {
        Navigator.pushNamed(context, AppRoutes.signIn);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: kTransparentColor,
      body: BackgroundWidget(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 15,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/logo.png',
                height: height * 0.08,
              ),
            ),
            Positioned(
              top: 75,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Image.asset(
                    _images[_currentPage],
                    key: ValueKey<int>(_currentPage),
                    height: height * 0.5,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 420,
              left: 0,
              right: 0,
              child: Container(
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
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Column(
                    key: ValueKey<int>(_currentPage),
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _titles[_currentPage],
                      const SizedBox(height: 5),
                      _bodies[_currentPage],
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: _currentPage < _images.length - 1
                    ? SizedBox(
                        width: 60,
                        height: 60,
                        child: FloatingActionButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          onPressed: _nextPage,
                          backgroundColor: kPrimaryColor,
                          child: const Icon(Icons.arrow_forward),
                        ),
                      )
                    : Row(
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
                              Navigator.pushNamed(context, AppRoutes.signUp);
                            },
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
