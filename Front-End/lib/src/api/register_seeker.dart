import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/route.dart'; // Adjust the import according to your project structure
import '../config/url.dart'; // Adjust the import according to your project structure

Future<void> registerSeeker(
  BuildContext context,
  TextEditingController firstNameController,
  TextEditingController lastNameController,
  TextEditingController emailController,
  TextEditingController phoneNumberController,
  TextEditingController passwordController,
) async {
  try {
    if (kDebugMode) {
      print('Sending request to $registerSeekersUrl');
      print('Request body: ${jsonEncode(<String, String>{
            'firstName': firstNameController.text,
            'lastName': lastNameController.text,
            'email': emailController.text,
            'phone': phoneNumberController.text,
            'password': passwordController.text,
          })}');
    }

    final response = await http.post(
      Uri.parse(registerSeekersUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'email': emailController.text,
        'phone': phoneNumberController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 201) {
      if (kDebugMode) {
        print('Success');
      }
      // Navigate to OTP page or show success message
      Navigator.pushNamed(
        context,
        AppRoutes.otppage,
        arguments: phoneNumberController.text,
      );
    } else if (response.statusCode == 409) {
      if (kDebugMode) {
        print('Phone number already exists');
      }
      throw Exception('Phone number already exists');
    } else {
      if (kDebugMode) {
        print('Failed to create user: ${response.body}');
      }
      throw Exception('Failed to create user');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Connection failed: $e');
    }
    throw Exception('Connection failed: $e');
  }
}
