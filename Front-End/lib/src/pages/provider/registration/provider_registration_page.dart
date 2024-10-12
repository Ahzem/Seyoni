import 'package:flutter/material.dart';
import 'package:seyoni/src/constants/constants_color.dart';
import 'package:seyoni/src/constants/constants_font.dart';
import 'package:seyoni/src/widgets/custom_button.dart';
import '../components/custom_text_field.dart';
import 'package:seyoni/src/widgets/background_widget.dart';
import 'package:seyoni/src/config/route.dart';

class ProviderRegistrationPage extends StatefulWidget {
  const ProviderRegistrationPage({super.key});

  @override
  ProviderRegistrationPageState createState() =>
      ProviderRegistrationPageState();
}

class ProviderRegistrationPageState extends State<ProviderRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  void _register() {
    if (_formKey.currentState!.validate()) {
      // Handle registration logic

      // Navigate to the provider home page
      Navigator.pushNamed(context, AppRoutes.providerHomePage);
    }
  }

  void _sendOtp() {
    // Handle sending OTP logic
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
                margin: const EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CustomTextField(
                        controller: _firstNameController,
                        labelText: 'First Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _lastNameController,
                        labelText: 'Last Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _emailController,
                        labelText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _phoneController,
                        labelText: 'Phone Number',
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _nicController,
                        labelText: 'NIC or Driving Licence',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your NIC or Driving Licence';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _passwordController,
                        labelText: 'New Password',
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _confirmPasswordController,
                        labelText: 'Confirm Password',
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _otpController,
                        labelText: 'OTP',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the OTP';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      PrimaryOutlinedButton(
                        text: 'Send OTP',
                        onPressed: _sendOtp,
                      ),
                      const SizedBox(height: 10),
                      PrimaryFilledButton(
                        text: 'Sign Up',
                        onPressed: _register,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account?',
                            style: TextStyle(
                              color: kParagraphTextColor,
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.providerSignIn);
                            },
                            child: const Text(
                              'Sign In',
                              style: TextStyle(color: kPrimaryColor),
                            ),
                          ),
                        ],
                      ),
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
