import 'package:flutter/material.dart';
import '../../../constants/constants_color.dart';
import '../../../constants/constants_font.dart';
import '../../../config/route.dart';
import '../../../widgets/background_widget.dart';
import '../../sign-pages/components/fields/email.dart';
import '../../../widgets/custom_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailEmpty = true;
  bool _isEmailValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
  }

  @override
  void dispose() {
    _emailController.removeListener(_onEmailChanged);
    _emailController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    final email = _emailController.text;
    setState(() {
      _isEmailEmpty = email.isEmpty;
      _isEmailValid = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTransparentColor,
      body: BackgroundWidget(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/Forgot-Password.png',
                  width: 100,
                  height: 100,
                ),
                const Text(
                  'Forgot Password',
                  style: kTitleTextStyle,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Enter your email address to reset your password',
                  style: kBodyTextStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                EmailField(
                  key: const Key('email-field'),
                  controller: _emailController,
                  errorText: !_isEmailValid && !_isEmailEmpty
                      ? 'Please enter a valid email address'
                      : null,
                ),
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        _isEmailEmpty
                            ? ''
                            : _isEmailValid
                                ? ''
                                : 'Invalid email',
                        style: kErrorTextStyle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PrimaryOutlinedButton(
                      text: 'Back to Sign In',
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.signIn);
                      },
                    ),
                    _isEmailEmpty || !_isEmailValid
                        ? PrimaryFilledInactiveButton(
                            text: 'Send OTP',
                            onPressed: () {},
                          )
                        : PrimaryFilledButton(
                            text: 'Send OTP',
                            onPressed: () {
                              final email = _emailController.text;
                              if (email.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Please enter your email')),
                                );
                              } else {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.otppagefornewpassword,
                                  arguments: email,
                                );
                              }
                            },
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
