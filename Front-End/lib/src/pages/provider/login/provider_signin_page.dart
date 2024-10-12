import 'package:flutter/material.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:seyoni/src/constants/constants_color.dart';
import 'package:seyoni/src/utils/validators.dart';
import 'package:seyoni/src/widgets/custom_button.dart';
import '../components/custom_text_field.dart';
import 'package:seyoni/src/widgets/background_widget.dart';
import 'package:seyoni/src/config/route.dart';

class ProviderSignInPage extends StatefulWidget {
  const ProviderSignInPage({super.key});

  @override
  ProviderSignInPageState createState() => ProviderSignInPageState();
}

class ProviderSignInPageState extends State<ProviderSignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      // Implement sign in logic here

      // Navigate to the provider home page
      Navigator.pushNamed(context, AppRoutes.providerHomePage);
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
                margin: const EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CustomTextField(
                        controller: _emailController,
                        labelText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.validateEmail,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _passwordController,
                        labelText: 'Password',
                        obscureText: true,
                        validator: Validators.validatePassword,
                      ),
                      const SizedBox(height: 20),
                      PrimaryFilledButton(
                        text: 'Sign In',
                        onPressed: _signIn,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account?',
                            style: TextStyle(
                              color: kParagraphTextColor,
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.providerSignUp);
                            },
                            child: const Text('Sign Up',
                                style: TextStyle(color: kPrimaryColor)),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Register as a service seeker',
                            style: TextStyle(
                              color: kParagraphTextColor,
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.signUp);
                            },
                            child: const Text('Register Now',
                                style: TextStyle(color: kPrimaryColor)),
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
