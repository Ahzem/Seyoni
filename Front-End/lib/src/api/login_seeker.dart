import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config/route.dart'; // Adjust the import according to your project structure
import '../config/url.dart'; // Adjust the import according to your project structure

Future<void> loginSeeker(
  BuildContext context,
  TextEditingController phoneNumberController,
  TextEditingController passwordController,
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
      if (kDebugMode) {
        print('Phone number already exists');
      }
      throw Exception('Phone number already exists');
    } else {
      if (kDebugMode) {
        print('Failed to login: ${response.body}');
      }
      throw Exception('Failed to login');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Connection failed: $e');
    }
    throw Exception('Connection failed: $e');
  }
}
