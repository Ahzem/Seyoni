import 'package:flutter/material.dart';
import '../../../widgets/custom_button.dart';
import '../../../config/route.dart';
import '../../../constants/constants_color.dart';
import '../../../constants/constants_font.dart';
import '../../../widgets/background_widget.dart';
import '../../sign-pages/components/fields/password.dart';
import '../../sign-pages/components/fields/confirmPw.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTransparentColor,
      body: BackgroundWidget(
        child: SingleChildScrollView(
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
                      controller: TextEditingController(),
                      errorText: 'Password is incorrect',
                    ),
                    const SizedBox(height: 10),
                    ConfirmPasswordField(
                      key: const Key('confirm_password'),
                      controller: TextEditingController(),
                      errorText: 'Password is incorrect',
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
                            Navigator.pushNamed(context, AppRoutes.home);
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
