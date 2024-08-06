import 'dart:async';
import 'package:flutter/material.dart';
import '../../../constants/constants_font.dart';
import '../../../config/route.dart';
import '../../../widgets/background_widget.dart';
import '../../../constants/constants_color.dart';
import '../otp/components/input_field.dart';
import '../otp/components/verify_button.dart';
import '../otp/components/resend_button.dart';

class OtpScreenForNewPassword extends StatefulWidget {
  const OtpScreenForNewPassword({super.key});

  @override
  _OtpScreenForNewPasswordState createState() =>
      _OtpScreenForNewPasswordState();
}

class _OtpScreenForNewPasswordState extends State<OtpScreenForNewPassword> {
  int _remainingTime = 30;
  Timer? _timer;
  bool _isResendButtonActive = false;
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  bool _isVerifyButtonActive = false;
  String _errorMessage = '';
  bool _isErrorVisible = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _controller1.addListener(_checkInputFields);
    _controller2.addListener(_checkInputFields);
    _controller3.addListener(_checkInputFields);
    _controller4.addListener(_checkInputFields);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        setState(() {
          _isResendButtonActive = true;
        });
        _timer?.cancel();
      }
    });
  }

  void _checkInputFields() {
    setState(() {
      _isVerifyButtonActive = _controller1.text.isNotEmpty &&
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

  void _verifyCode() {
    // Replace this with your actual verification logic
    bool isCodeCorrect = _controller1.text == '1' &&
        _controller2.text == '2' &&
        _controller3.text == '3' &&
        _controller4.text == '4';

    if (isCodeCorrect) {
      Navigator.pushNamed(context, AppRoutes.resetPassword);
    } else {
      setState(() {
        _errorMessage = 'The code you entered is incorrect. Please try again.';
        _isErrorVisible = true;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
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
    final String email =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'your email';
    return Scaffold(
      backgroundColor: kBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: BackgroundWidget(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                  'assets/icons/One-Time-Password.png',
                  height: 100,
                ),
                const SizedBox(height: 20),
                const Text(
                  'OTP Verification',
                  style: kTitleTextStyle,
                ),
                const SizedBox(height: 20),
                Text(
                  'A 4-digit code has been sent to $email. Please enter the code below.',
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
                if (_isErrorVisible)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                _isVerifyButtonActive
                    ? VerifyButton(
                        onPressed: _verifyCode,
                      )
                    : VerifyButtonInactive(
                        onPressed: () {
                          // Do nothing or show a message
                        },
                      ),
                const SizedBox(height: 10),
                Text(
                  _remainingTime > 0
                      ? 'Resend code in 00:${_remainingTime.toString().padLeft(2, '0')}'
                      : '',
                  style: const TextStyle(
                    color: kPrimaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                _isResendButtonActive
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Didn\'t receive the code?',
                            style: kBodyTextStyle,
                          ),
                          ResendFlatButton(
                            onPressed: () {},
                          ),
                        ],
                      )
                    : const SizedBox(width: 0, height: 0),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
