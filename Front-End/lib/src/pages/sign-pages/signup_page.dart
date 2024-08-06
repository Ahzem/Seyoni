import 'package:flutter/material.dart';
import '../../config/route.dart';
import '../../pages/sign-pages/components/buttons/sign_in.dart';
import '../../constants/constants_color.dart';
import '../../widgets/background_widget.dart';
import 'components/fields/phone_num.dart';
import 'components/fields/email.dart';
import 'components/fields/password.dart';
import 'components/fields/confirmPw.dart';
import 'components/fields/name.dart';
import 'components/buttons/google.dart';
import 'components/buttons/facebook.dart';
import 'components/buttons/sign_up.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  SignUpPage({super.key});

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
                margin: const EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: FNameField(
                              key: const Key('first-name-field'),
                              controller: _firstNameController,
                              errorText: 'First name is incorrect',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: LNameField(
                              key: const Key('last-name-field'),
                              controller: _lastNameController,
                              errorText: 'Last name is incorrect',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      EmailField(
                        key: const Key('email'),
                        controller: _emailController,
                        errorText: 'Email is incorrect',
                      ),
                      const SizedBox(height: 10),
                      PhoneNumberField(
                        key: const Key('phone_number'),
                        controller: phoneNumberController,
                        errorText: 'Phone number is incorrect',
                      ),
                      const SizedBox(height: 10),
                      PasswordField(
                        key: const Key('password'),
                        controller: _passwordController,
                      ),
                      const SizedBox(height: 10),
                      ConfirmPasswordField(
                        key: const Key('confirm_password'),
                        controller: _confirmPasswordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please re-enter your password';
                          } else if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      SignUpButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.otppage,
                              arguments: phoneNumberController.text,
                            );
                          }
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: kParagraphTextColor,
                              fontSize: 14,
                            ),
                          ),
                          FlatenSignInButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.signIn);
                            },
                          ),
                        ],
                      ),
                      const Text(
                        'Or sign Up with',
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
