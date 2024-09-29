import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/route.dart';
import '../config/url.dart';
import '../widgets/alertbox/alredy_exist.dart';

Future<Map<String, String>?> registerSeeker(
  BuildContext context,
  TextEditingController firstNameController,
  TextEditingController lastNameController,
  TextEditingController emailController,
  TextEditingController phoneNumberController,
  TextEditingController passwordController,
) async {
  try {
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
      return {
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'email': emailController.text,
        'phone': phoneNumberController.text,
        'password': passwordController.text,
      };
    } else if (response.statusCode == 409) {
      if (!context.mounted) return null;
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
    } else {
      if (kDebugMode) {
        print('Failed');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Failed');
      print(e);
    }
  }
  return null;
}
