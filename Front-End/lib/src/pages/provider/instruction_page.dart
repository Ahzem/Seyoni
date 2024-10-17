import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/background_widget.dart';
import '../../constants/constants_color.dart';
import '../../config/route.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/constants_font.dart';
import 'components/register_button.dart';

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
  InstructionPageState createState() => InstructionPageState();
}

class InstructionPageState extends State<InstructionPage> {
  int _currentPage = 0;
  final PageController _pageController = PageController();
  final List<String> _images = ['assets/svg/technicians-1.svg'];
  final List<Widget> _titles = [
    const Text('Become a Service Provider'),
  ];
  final List<Widget> _bodies = [
    const Text(
        'Join our platform as a service provider and start earning money by providing services to customers.'),
  ];

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
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/logo.png',
                      height: height * 0.08,
                    ),
                    SizedBox(height: height * 0.01), // Adjusted spacing
                    Center(
                      child: SizedBox(
                        height: height * 0.5,
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemCount: _images.length,
                          itemBuilder: (context, index) {
                            return SvgPicture.asset(
                              _images[index],
                              height: height * 0.5,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 20,
                  ),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kContainerColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: kBoarderColor,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _titles[_currentPage],
                      const SizedBox(height: 2),
                      _bodies[_currentPage],
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                Center(
                  child: _currentPage < _images.length - 1
                      ? const Column(
                          children: [
                            SizedBox(height: 20),
                          ],
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
                                        context, AppRoutes.providerSignIn);
                                  },
                                ),
                                Container(width: 15),
                                PrimaryFilledButton(
                                  text: 'Sign Up',
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, AppRoutes.providerSignUp);
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Register as a service seeker',
                                  style: kBodyTextStyle,
                                ),
                                RegisterFlatButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, AppRoutes.signUp);
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
