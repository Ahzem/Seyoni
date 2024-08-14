import 'package:flutter/material.dart';

Future<Map<String, String>?> registerSeeker(
  BuildContext context,
  TextEditingController firstNameController,
  TextEditingController lastNameController,
  TextEditingController emailController,
  TextEditingController phoneNumberController,
  TextEditingController passwordController,
) async {
  return {
    'firstName': firstNameController.text,
    'lastName': lastNameController.text,
    'email': emailController.text,
    'phone': phoneNumberController.text,
    'password': passwordController.text,
  };
}
