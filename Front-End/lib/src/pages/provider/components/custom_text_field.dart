import 'package:flutter/material.dart';
import 'package:seyoni/src/constants/constants_color.dart';
import 'package:seyoni/src/constants/constants_font.dart';

import '../../seeker/sign-pages/components/constants.dart';

const double height = 10;
const double width = 30.0;

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomTextField({
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: kTextFieldStyle,
      decoration: InputDecoration(
        filled: false,
        fillColor: kContainerColor,
        errorMaxLines: 3,
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          borderSide: BorderSide(color: kErrorColor),
        ),
        labelText: labelText,
        labelStyle: kBodyTextStyle,
        prefixIcon: Icon(
          _getPrefixIcon(labelText),
          size: 25,
          color: kPrimaryColor,
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 50),
        suffixIcon: obscureText
            ? const Icon(
                Icons.visibility_off,
                size: 20,
                color: kParagraphTextColor,
              )
            : null,
        suffixIconConstraints: const BoxConstraints(minWidth: 50),
        contentPadding: const EdgeInsets.symmetric(
          vertical: height,
          horizontal: width,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          borderSide: BorderSide(color: kPrimaryColor),
        ),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  IconData _getPrefixIcon(String labelText) {
    switch (labelText.toLowerCase()) {
      case 'email':
        return Icons.email_outlined;
      case 'phone number':
        return Icons.phone_outlined;
      case 'nic or driving licence':
        return Icons.badge_outlined;
      case 'new password':
      case 'confirm password':
        return Icons.lock_outline_rounded;
      case 'otp':
        return Icons.security_outlined;
      default:
        return Icons.person_outline;
    }
  }
}
