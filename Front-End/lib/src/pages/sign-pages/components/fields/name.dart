import 'package:flutter/material.dart';
import '../constants.dart';
import '../decor/name.dart';
import '../../../../constants/constants_color.dart';

// Sign up form:

// Name field
class FNameField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;

  const FNameField({
    required Key key,
    required this.controller,
    required this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 0.4,
      child: TextFormField(
        controller: controller,
        style: kTextFieldStyle,
        decoration: kFNameFieldDecoration,
        cursorColor: kPrimaryColor,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
      ),
    );
  }
}

// Last name field
class LNameField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;

  const LNameField({
    required Key key,
    required this.controller,
    required this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 0.4,
      child: TextFormField(
        controller: controller,
        style: kTextFieldStyle,
        decoration: kLNameFieldDecoration,
        cursorColor: kPrimaryColor,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
      ),
    );
  }
}
