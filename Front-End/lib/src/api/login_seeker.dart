import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config/route.dart';
import '../config/url.dart';
import '../widgets/alertbox/incorrect_password.dart';
import '../widgets/alertbox/seeker_not_found.dart';

Future<void> loginSeeker(
  BuildContext context,
  TextEditingController emailController,
  TextEditingController passwordController,
) async {
  try {
    if (kDebugMode) {
      print('Sending request to $loginSeekersUrl');
      print('Request body: ${jsonEncode(<String, String>{
            'email': emailController.text,
            'password': passwordController.text,
          })}');
    }

    final response = await http.post(
      Uri.parse(loginSeekersUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': emailController.text,
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
    } else if (response.statusCode == 404) {
      // call the alert box
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SeekerNotFound(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.signUp);
            },
          );
        },
      );
    } else if (response.statusCode == 401) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error'] == 'User not found') {
        // call the alert box
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SeekerNotFound(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.signUp);
              },
            );
          },
        );
      } else {
        // call the alert box
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return IncorrectPassword(
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        );
      }
    } else {
      throw Exception('Failed to login seeker');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Failed');
    }
  }
}
