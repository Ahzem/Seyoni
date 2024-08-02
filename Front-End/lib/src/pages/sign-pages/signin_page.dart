import 'package:flutter/material.dart';
import 'package:seyoni/src/config/route.dart';
import 'components/buttons/sign_up.dart';
import '../../constants/constants_color.dart';
import '../../widgets/background_widget.dart';
import 'components/fields/email.dart';
import 'components/fields/password.dart';
import 'components/buttons/google.dart';
import 'components/buttons/facebook.dart';
import 'components/buttons/sign_in.dart';
import 'components/buttons/forgot_pw.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kTransparentColor,
      body: BackgroundWidget(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: height * 0.1), // Adjust top spacing
              Image.asset(
                'assets/images/logo-icon.png',
                height: height * 0.15,
                fit: BoxFit.contain,
              ),
              Image.asset(
                'assets/images/logo-name.png',
                height: height * 0.12,
                fit: BoxFit.contain,
              ),
              Container(
                width: width * 0.8, // Adjust width to fit the screen
                margin: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    EmailField(
                      key: const Key('email-field'),
                      controller: TextEditingController(),
                      errorText: 'Email is incorrect',
                    ),
                    const SizedBox(height: 10),
                    PasswordField(
                      key: const Key('password-field'),
                      controller: TextEditingController(),
                      errorText: 'Password is incorrect',
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ForgotPasswordButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot-password');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SignInButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.home);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Don\'t have an account? ',
                          style: TextStyle(
                            color: kParagraphTextColor,
                            fontSize: 14,
                          ),
                        ),
                        FlatenSignUpButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.signUp);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Or sign in with',
                      style: TextStyle(
                        color: kParagraphTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SignInWithGoogleButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.home);
                          },
                        ),
                        SignInWithFacebookButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.home);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20), // Adjust bottom spacing
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
