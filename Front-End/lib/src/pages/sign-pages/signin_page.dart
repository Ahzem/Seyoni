import 'package:flutter/material.dart';
import '../../constants/constants_color.dart';
import '../../widgets/background_widget.dart';
import 'components/signin_fields.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kTransparentColor,
      body: BackgroundWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/logo-icon.png',
              height: height * 0.15,
              fit: BoxFit.cover,
            ),
            Image.asset(
              'assets/images/logo-name.png',
              height: height * 0.12,
              fit: BoxFit.cover,
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
                  const SizedBox(height: 10),
                  SignInButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                  ),
                  const SizedBox(height: 10),
                  SignUpButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ForgotPasswordButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/forgot-password');
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SignInWithGoogleButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                  ),
                  const SizedBox(height: 10),
                  SignInWithFacebookButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                  ),
                  const SizedBox(height: 10),
                  SignInWithAppleButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
