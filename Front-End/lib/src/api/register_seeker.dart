import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/route.dart';
import '../config/url.dart';
import '../widgets/alertbox/alredy_exist.dart';

Future<Map<String, String>?> validateSeekerData(
  BuildContext context,
  TextEditingController firstNameController,
  TextEditingController lastNameController,
  TextEditingController emailController,
  TextEditingController phoneNumberController,
  TextEditingController passwordController,
) async {
  // Here you can add any additional validation logic if needed
  return {
    'firstName': firstNameController.text,
    'lastName': lastNameController.text,
    'email': emailController.text,
    'phone': phoneNumberController.text,
    'password': passwordController.text,
  };
}

Future<bool> registerSeekerToBackend(
    Map<String, String> userData, BuildContext context) async {
  try {
    final response = await http.post(
      Uri.parse(registerSeekersUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 409) {
      if (!context.mounted) return false;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlredyExist(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.signIn);
            },
          );
        },
      );
      return false;
    } else {
      if (kDebugMode) {
        print('Failed');
      }
      return false;
    }
  } catch (e) {
    if (kDebugMode) {
      print('Failed');
      print(e);
    }
    return false;
  }
}

Future<bool> verifyOtpAndRegisterSeeker(
    Map<String, String> userData, String otp, BuildContext context) async {
  try {
    final response = await http.post(
      Uri.parse(verifyOtpUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'phone': userData['phone'], 'otp': otp}),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      if (kDebugMode) {
        print('Failed');
      }
      return false;
    }
  } catch (e) {
    if (kDebugMode) {
      print('Failed');
      print(e);
    }
    return false;
  }
}
