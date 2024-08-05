import 'package:flutter/material.dart';
import '../constants.dart';
import '../../../../constants/constants_color.dart';
import '../decor/phoneNum.dart';

// Sign up form:

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
      decoration: kPhoneNumberFieldDecoration,
      cursorColor: kPrimaryColor,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
    );
  }
}
