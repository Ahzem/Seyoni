import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/url.dart';
import 'dart:convert';

class AuthService {
  static const String signOutUrl = '$url/api/seeker/signout';

  Future<void> signOut() async {
    final response = await http.post(
      Uri.parse(signOutUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Handle successful sign-out
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
    } else {
      // Handle error
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}

Future<void> signIn(String email, String password) async {
  final response = await http.post(
    Uri.parse('$url/api/seeker/signin'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    final token = jsonDecode(response.body)['token'];
    final authService = AuthService();
    await authService.saveToken(token);
  } else {}
}
