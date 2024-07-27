import 'package:flutter/material.dart';
import '../../../constants/constants_color.dart';
import 'constants.dart';

// Sign in form:

// Email field
class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;

  const EmailField({
    required Key key,
    required this.controller,
    required this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: kTextFieldStyle,
      decoration:
          errorText == null ? kTextFieldDecoration : kTextFieldErrorDecoration,
      cursorColor: kPrimaryColor,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
    );
  }
}

// Password field
class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;

  const PasswordField({
    required Key key,
    required this.controller,
    required this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: kTextFieldStyle,
      decoration: errorText == null
          ? kPasswordFieldDecoration
          : kPasswordFieldErrorDecoration,
      cursorColor: kPrimaryColor,
      obscureText: true,
      textInputAction: TextInputAction.done,
    );
  }
}

// Sign in button
class SignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.1,
          vertical: height * 0.02,
        ),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      child: const Text(
        'Sign In',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

// Sign up button
class SignUpButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SignUpButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: kPrimaryColor),
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.1,
          vertical: height * 0.02,
        ),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      child: const Text(
        'Sign Up',
        style: TextStyle(color: kPrimaryColor),
      ),
    );
  }
}

// Forgot password button
class ForgotPasswordButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ForgotPasswordButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Text(
        'Forgot Password?',
        style: TextStyle(
          color: kPrimaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// Sign in with Google button
class SignInWithGoogleButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SignInWithGoogleButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: kPrimaryColor),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      child: const Text(
        'Sign In with Google',
        style: TextStyle(color: kPrimaryColor),
      ),
    );
  }
}

// Sign in with Facebook button
class SignInWithFacebookButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SignInWithFacebookButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: kPrimaryColor),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      child: const Text(
        'Sign In with Facebook',
        style: TextStyle(color: kPrimaryColor),
      ),
    );
  }
}

// Sign in with Apple button
class SignInWithAppleButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SignInWithAppleButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: kPrimaryColor),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      child: const Text(
        'Sign In with Apple',
        style: TextStyle(color: kPrimaryColor),
      ),
    );
  }
}
