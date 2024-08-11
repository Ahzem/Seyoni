import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config/route.dart'; // Adjust the import according to your project structure
import '../config/url.dart'; // Adjust the import according to your project structure
import '../widgets/alertbox/incorrect_password.dart';
import '../widgets/alertbox/seeker_not_found.dart';

Future<void> loginSeeker(
  BuildContext context,
  TextEditingController phoneNumberController,
  TextEditingController passwordController,
  ValueNotifier<String?> errorNotifier,
) async {
  try {
    if (kDebugMode) {
      print('Sending request to $loginSeekersUrl');
      print('Request body: ${jsonEncode(<String, String>{
            'phone': phoneNumberController.text,
            'password': passwordController.text,
          })}');
    }

    final response = await http.post(
      Uri.parse(loginSeekersUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phone': phoneNumberController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', jsonResponse['token']);
      Navigator.pushNamed(
        context,
        AppRoutes.home,
        arguments: jsonResponse['token'],
      );
    } else if (response.statusCode == 409) {
      // call the alert box
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SeekerDoesntExist(
            onPressed: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
      errorNotifier.value = 'Seeker not found';
    } else if (response.statusCode == 401) {
      // call the alert box
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return IncorrectPassword(
            onPressed: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
      errorNotifier.value = 'Incorrect password';
    } else {
      if (kDebugMode) {
        print('Failed to login: ${response.body}');
      }
      errorNotifier.value = 'Failed to login';
    }
  } catch (e) {
    if (kDebugMode) {
      print('Connection failed: $e');
    }
    errorNotifier.value = 'Connection failed: $e';
  }
}
