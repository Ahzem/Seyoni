import 'package:flutter/material.dart';
import 'constants.dart';
import '../../../constants/constants_color.dart';

// Sign up form:

// Name field
class NameField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;

  const NameField({
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
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
    );
  }
}

// Phone number field
class PhoneNumberField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;

  const PhoneNumberField({
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
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
    );
  }
}

// Email field
class EmailFieldSignUp extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;

  const EmailFieldSignUp({
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
class PasswordFieldSignUp extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;

  const PasswordFieldSignUp({
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

// Confirm password field
class ConfirmPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;

  const ConfirmPasswordField({
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
