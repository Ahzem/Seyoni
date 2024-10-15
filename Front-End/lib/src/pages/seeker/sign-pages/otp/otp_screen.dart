import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../api/register_seeker.dart';
import '../../../../constants/constants_font.dart';
import '../../../../config/route.dart';
import '../../../../widgets/background_widget.dart';
import '../../../../constants/constants_color.dart';
import 'components/input_field.dart';
import 'components/verify_button.dart';
import '../../../../widgets/alertbox/verification_success.dart';
import 'components/resend_button.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  OtpScreenState createState() => OtpScreenState();
}

class OtpScreenState extends State<OtpScreen> {
  int _remainingTime = 59;
  Timer? _timer;
  bool _isResendButtonActive = false;
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  final TextEditingController _controller5 = TextEditingController();
  final TextEditingController _controller6 = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();

  bool _isVerifyButtonActive = false;
  bool _isErrorVisible = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
    _controller1.addListener(_checkInputFields);
    _controller2.addListener(_checkInputFields);
    _controller3.addListener(_checkInputFields);
    _controller4.addListener(_checkInputFields);
    _controller5.addListener(_checkInputFields);
    _controller6.addListener(_checkInputFields);
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
          _controller4.text.isNotEmpty &&
          _controller5.text.isNotEmpty &&
          _controller6.text.isNotEmpty;
    });
  }

  void _nextField(String value, FocusNode currentFocus, FocusNode nextFocus) {
    if (value.isNotEmpty) {
      currentFocus.unfocus();
      FocusScope.of(context).requestFocus(nextFocus);
    }
  }

  Future<void> _verifyCode() async {
    final otp = _controller1.text +
        _controller2.text +
        _controller3.text +
        _controller4.text +
        _controller5.text +
        _controller6.text;

    final userData =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    if (userData == null) {
      setState(() {
        _errorMessage = 'User data is missing. Please try again.';
        _isErrorVisible = true;
      });
      return;
    }

    final success = await verifyOtpAndRegisterSeeker(userData, otp, context);
    if (!mounted) return;

    if (success) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('firstName', userData['firstName'].toString());
      await prefs.setString('lastName', userData['lastName'].toString());
      await prefs.setString('email', userData['email'].toString());
      showDialog(
        context: context,
        builder: (context) {
          return VerificationSuccess(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.signIn,
                (route) => false,
              );
            },
          );
        },
      );
    } else {
      setState(() {
        _errorMessage = 'The code you entered is incorrect. Please try again.';
        _isErrorVisible = true;
      });
    }
  }

  Future<void> _resendOtp() async {
    final userData =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    final phone = userData['phone'];

    final success = await resendOtp(phone, context);

    if (success) {
      setState(() {
        _remainingTime = 59;
        _isResendButtonActive = false;
        _startTimer();
      });
    } else {
      setState(() {
        _errorMessage = 'Failed to resend OTP. Please try again.';
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
    _controller5.dispose();
    _controller6.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    _focusNode5.dispose();
    _focusNode6.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    final String phoneNumber = arguments?['phone'] ?? 'your number';
    return Scaffold(
      backgroundColor: kTransparentColor,
      body: BackgroundWidget(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
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
                  'assets/icons/AlertBox/One-Time-Password.png',
                  height: 100,
                ),
                const SizedBox(height: 20),
                const Text(
                  'OTP Verification',
                  style: kTitleTextStyle,
                ),
                const SizedBox(height: 20),
                Text(
                  'A 6-digit code has been sent to $phoneNumber. Please enter the code below.',
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
                    const SizedBox(width: 6),
                    InputBox(
                      controller: _controller2,
                      focusNode: _focusNode2,
                      onChanged: (value) =>
                          _nextField(value, _focusNode2, _focusNode3),
                    ),
                    const SizedBox(width: 6),
                    InputBox(
                      controller: _controller3,
                      focusNode: _focusNode3,
                      onChanged: (value) =>
                          _nextField(value, _focusNode3, _focusNode4),
                    ),
                    const SizedBox(width: 6),
                    InputBox(
                      controller: _controller4,
                      focusNode: _focusNode4,
                      onChanged: (value) =>
                          _nextField(value, _focusNode4, _focusNode5),
                    ),
                    const SizedBox(width: 6),
                    InputBox(
                      controller: _controller5,
                      focusNode: _focusNode5,
                      onChanged: (value) =>
                          _nextField(value, _focusNode5, _focusNode6),
                    ),
                    const SizedBox(width: 6),
                    InputBox(
                      controller: _controller6,
                      focusNode: _focusNode6,
                      onChanged: (value) =>
                          _nextField(value, _focusNode6, FocusNode()),
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
                            onPressed: _resendOtp,
                          ),
                        ],
                      )
                    : const SizedBox(width: 0, height: 0),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
