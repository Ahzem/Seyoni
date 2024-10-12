import 'package:flutter/material.dart';
import '../decor/referral_code.dart';

class ReferralCodeField extends StatelessWidget {
  final TextEditingController controller;
  final String errorText;
  const ReferralCodeField({required Key key, required this.controller, required this.errorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: kReferralFieldDecoration,
    );
  }
}