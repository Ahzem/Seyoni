import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/background_widget.dart';
import '../../constants/constants_color.dart';
import 'components/instructions_data.dart';
import '../../config/route.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    'assets/svg/technicians-1.svg',
    'assets/svg/technicians-2.svg',
    'assets/svg/technicians-3.svg',
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
    double width = MediaQuery.of(context).size.width;
    double topPadding = MediaQuery.of(context).padding.top;
    double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: kTransparentColor,
      body: BackgroundWidget(
        child: SingleChildScrollView(
          child: Container(
            height: height,
            width: width,
            padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/logo.png',
                      height: height * 0.08,
                    ),
                    SizedBox(height: height * 0.02), // Adjusted spacing
                    Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: SvgPicture.asset(
                          _images[_currentPage],
                          key: ValueKey<int>(_currentPage),
                          height: height * 0.5,
                        ),
                      ),
                    ),
                  ],
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
                Center(
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
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PrimaryOutlinedButton(
                                  text: 'Sign In',
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, AppRoutes.signIn);
                                  },
                                ),
                                Container(width: 15),
                                PrimaryFilledButton(
                                  text: 'Sign Up',
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, AppRoutes.signUp);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
                Container(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
