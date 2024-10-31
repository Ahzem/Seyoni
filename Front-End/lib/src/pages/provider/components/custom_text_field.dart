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
  final bool? enabled;

  const CustomTextField({
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.enabled,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: kPrimaryColor,
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
      case 'new password':
        return Icons.lock_open_outlined;
      case 'password':
        return Icons.lock_outline_rounded;
      case 'confirm password':
        return Icons.lock_outline_rounded;
      case 'enter otp':
        return Icons.security_outlined;
      case 'first name':
        return Icons.person_outline;
      case 'last name':
        return Icons.person_outline;
      case 'location':
        return Icons.location_on_outlined;
      case 'address':
        return Icons.location_on_outlined;
      default:
        return Icons.text_fields;
    }
  }
}
