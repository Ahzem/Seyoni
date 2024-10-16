import 'package:flutter/material.dart';
import 'package:seyoni/src/constants/constants_color.dart';
import 'package:seyoni/src/constants/constants_font.dart';

import '../../seeker/sign-pages/components/constants.dart';

class ShortCustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const ShortCustomTextField({
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 0.42,
      child: TextFormField(
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
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
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
      ),
    );
  }
}
