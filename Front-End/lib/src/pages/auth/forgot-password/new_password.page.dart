import 'package:flutter/material.dart';
import '../../../widgets/custom_button.dart';
import '../../../config/route.dart';
import '../../../constants/constants_color.dart';
import '../../../constants/constants_font.dart';
import '../../../widgets/background_widget.dart';
import '../../sign-pages/components/fields/password.dart';
import '../../sign-pages/components/fields/confirmPw.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (value.contains(RegExp(r'[A-Z]')) == false) {
      return 'Password must contain at least one uppercase letter';
    }
    if (value.contains(RegExp(r'[a-z]')) == false) {
      return 'Password must contain at least one lowercase letter';
    }
    if (value.contains(RegExp(r'[0-9]')) == false) {
      return 'Password must contain at least one number';
    }
    if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')) == false) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTransparentColor,
      body: BackgroundWidget(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/icons/Password-Reset.png',
                        width: 100,
                        height: 100,
                      ),
                      const Text(
                        'Reset Password',
                        style: kTitleTextStyle,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Please enter your new password',
                        style: kBodyTextStyle,
                      ),
                      const SizedBox(height: 20),
                      PasswordField(
                        key: const Key('password'),
                        controller: _passwordController,
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 10),
                      ConfirmPasswordField(
                        key: const Key('confirm_password'),
                        controller: _confirmPasswordController,
                        validator: _validateConfirmPassword,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          PrimaryOutlinedButton(
                            text: 'Back to Sign In',
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.signIn);
                            },
                          ),
                          const SizedBox(width: 10),
                          PrimaryFilledButton(
                            text: 'Confirm',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.pushNamed(context, AppRoutes.home);
                              }
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 50),
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
