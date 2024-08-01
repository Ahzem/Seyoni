import 'package:flutter/material.dart';
import '../../constants/constants_font.dart';
import '../../config/route.dart';
import '../../widgets/background_widget.dart';
import '../../constants/constants_color.dart';
import 'components/input_field.dart';
import 'components/verify_button.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();

  bool _isButtonActive = false;

  @override
  void initState() {
    super.initState();
    _controller1.addListener(_checkInputFields);
    _controller2.addListener(_checkInputFields);
    _controller3.addListener(_checkInputFields);
    _controller4.addListener(_checkInputFields);
  }

  void _checkInputFields() {
    setState(() {
      _isButtonActive = _controller1.text.isNotEmpty &&
          _controller2.text.isNotEmpty &&
          _controller3.text.isNotEmpty &&
          _controller4.text.isNotEmpty;
    });
  }

  void _nextField(String value, FocusNode currentFocus, FocusNode nextFocus) {
    if (value.isNotEmpty) {
      currentFocus.unfocus();
      FocusScope.of(context).requestFocus(nextFocus);
    }
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String phoneNumber =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'your number';
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: [
          BackgroundWidget(
            child: SafeArea(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        color: kPrimaryColor,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Image.asset(
                      'assets/icons/Authentication.png',
                      height: 100,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'OTP Verification',
                      style: kTitleTextStyle,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'A 4-digit code has been sent to $phoneNumber. Please enter the code below.',
                      style: kBodyTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InputBox(
                          controller: _controller1,
                          focusNode: _focusNode1,
                          onChanged: (value) =>
                              _nextField(value, _focusNode1, _focusNode2),
                        ),
                        const SizedBox(width: 10),
                        InputBox(
                          controller: _controller2,
                          focusNode: _focusNode2,
                          onChanged: (value) =>
                              _nextField(value, _focusNode2, _focusNode3),
                        ),
                        const SizedBox(width: 10),
                        InputBox(
                          controller: _controller3,
                          focusNode: _focusNode3,
                          onChanged: (value) =>
                              _nextField(value, _focusNode3, _focusNode4),
                        ),
                        const SizedBox(width: 10),
                        InputBox(
                          controller: _controller4,
                          focusNode: _focusNode4,
                          onChanged: (value) =>
                              _nextField(value, _focusNode4, FocusNode()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Resend code in 00:30',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _isButtonActive
                        ? VerifyButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.home);
                            },
                          )
                        : VerifyButtonInactive(
                            onPressed: () {
                              // Do nothing or show a message
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
