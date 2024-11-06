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
      await prefs.setString('token', jsonResponse['token']);
      await prefs.setString('firstName', jsonResponse['seeker']['firstName']);
      await prefs.setString('lastName', jsonResponse['seeker']['lastName']);
      await prefs.setString('email', jsonResponse['seeker']['email']);
      await prefs.setString('seekerId', jsonResponse['seeker']['_id']);
      await prefs.setString('phone', jsonResponse['seeker']['phone']);
      await prefs.setString(
          'profileImageUrl', jsonResponse['seeker']['profileImageUrl']);
      await prefs.setString('address', jsonResponse['seeker']['address']);

      // final seekerId = jsonResponse['seeker']['_id'];
      // Provider.of<NotificationProvider>(context, listen: false)
      //   ..ensureConnection()
      //   ..identifyUser(seekerId, 'seeker');

      // Check if the widget is still mounted before using the context

      if (!context.mounted) return;
      Navigator.pushNamed(context, AppRoutes.home);
    } else if (response.statusCode == 404) {
      // Check if the widget is still mounted before using the context
      if (!context.mounted) return;

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

      // Check if the widget is still mounted before using the context
      if (!context.mounted) return;

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
