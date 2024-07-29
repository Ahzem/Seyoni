import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../../constants/constants_color.dart';
import '../constants.dart';
import '../decor/confirmPw.dart';

// Sign in form:

class ConfirmPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String? errorText;
  const ConfirmPasswordField({
    required Key key,
    required this.controller,
    required this.errorText,
  }) : super(key: key);

  @override
  _ConfirmPasswordFieldState createState() => _ConfirmPasswordFieldState();
}

class _ConfirmPasswordFieldState extends State<ConfirmPasswordField> {
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      style: kTextFieldStyle,
      decoration: widget.errorText == null
          ? kConfirmPasswordFieldDecoration.copyWith(
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: kParagraphTextColor,
                ),
                onPressed: _togglePasswordVisibility,
              ),
            )
          : kConfirmPasswordErrorDecoration.copyWith(
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: kParagraphTextColor,
                ),
                onPressed: _togglePasswordVisibility,
              ),
            ),
      cursorColor: kPrimaryColor,
      obscureText: !_isPasswordVisible,
      textInputAction: TextInputAction.done,
    );
  }
}
