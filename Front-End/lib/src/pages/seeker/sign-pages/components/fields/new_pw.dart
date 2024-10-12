import 'package:flutter/material.dart';
import '../../../../../constants/constants_color.dart';
import '../../../../../utils/validators.dart';
import '../constants.dart';
import '../decor/new_pw.dart';

class NewPasswordField extends StatefulWidget {
  final TextEditingController controller;

  const NewPasswordField({
    required Key key,
    required this.controller,
  }) : super(key: key);

  @override
  NewPasswordFieldState createState() => NewPasswordFieldState();
}

class NewPasswordFieldState extends State<NewPasswordField> {
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
      decoration: kNewPasswordFieldDecoration.copyWith(
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
      onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
      validator: Validators.validatePassword,
    );
  }
}
