import 'package:flutter/material.dart';
import 'package:seyoni/src/pages/sign-pages/components/fields/email.dart';
import '../../config/route.dart';
import 'components/buttons/sign_up.dart';
import '../../constants/constants_color.dart';
import '../../widgets/background_widget.dart';
import 'components/fields/password.dart';
import 'components/buttons/google.dart';
import 'components/buttons/facebook.dart';
import 'components/buttons/sign_in.dart';
import 'components/buttons/forgot_pw.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/login_seeker.dart'; // Import the loginSeeker function

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _loadSharedPreferences();
  }

  Future<void> _loadSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        await loginSeeker(
          context,
          emailController,
          passwordController,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sign in: $e'),
            backgroundColor: kErrorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
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
                // Adjust width to fit the screen
                margin: const EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      EmailField(
                        key: const Key('phone-num-field'),
                        controller: emailController,
                        errorText: 'Phone number is incorrect',
                      ),
                      const SizedBox(height: 10),
                      PasswordField(
                        key: const Key('password-field'),
                        controller: passwordController,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          ForgotPasswordButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.forgotpassword);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SignInButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            loginSeeker(
                              context,
                              emailController,
                              passwordController,
                            );
                          }
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
                      const SizedBox(height: 10),
                      const Text(
                        'Or sign in with',
                        style: TextStyle(
                          color: kParagraphTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 10), // Adjust bottom spacing
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
