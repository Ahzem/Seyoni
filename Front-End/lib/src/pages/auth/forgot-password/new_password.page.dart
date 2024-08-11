import 'package:flutter/material.dart';
import '../../../widgets/custom_button.dart';
import '../../../config/route.dart';
import '../../../constants/constants_color.dart';
import '../../../constants/constants_font.dart';
import '../../../widgets/background_widget.dart';
import '../../sign-pages/components/fields/password.dart';
import '../../sign-pages/components/fields/confirm_pw.dart';
import '../../../widgets/alertbox/password_changed.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ResetPasswordPageState createState() => ResetPasswordPageState();
}

class ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return PasswordChanged(
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
