import 'package:flutter/material.dart';
import '../constants.dart';
import '../../../../constants/constants_color.dart';
import '../decor/phone_num.dart';

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
      validator: (value) {
        if (value!.isEmpty) {
          return errorText;
        } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
          return 'Invalid phone number';
        }
        return null;
      },
    );
  }
}
