import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../../constants/constants_color.dart';
import '../constants.dart';
import '../decor/newPw.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String? errorText;
  const PasswordField({
    required Key key,
    required this.controller,
    required this.errorText,
  }) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
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
          ? kNewPasswordFieldDecoration.copyWith(
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: kParagraphTextColor,
                ),
                onPressed: _togglePasswordVisibility,
              ),
            )
          : kNewPasswordErrorDecoration.copyWith(
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
