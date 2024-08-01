import 'package:flutter/material.dart';
import '../../../../constants/constants_color.dart';
import '../constants.dart';
import '../decor/text.dart';

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
