// Create new file: lib/src/services/logout_service.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seyoni/src/config/route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/provider/notification/notification_provider.dart';

class LogoutService {
  static Future<void> logout(BuildContext context, bool isProvider) async {
    try {
      // 1. Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // 2. Reset NotificationProvider state
      if (context.mounted) {
        final provider =
            Provider.of<NotificationProvider>(context, listen: false);
        provider.reset(); // This closes WebSocket and resets all state
      }

      // 3. Navigate to appropriate login screen
      if (context.mounted) {
        Navigator.pushReplacementNamed(
            context, isProvider ? AppRoutes.providerSignIn : AppRoutes.signIn);
      }
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }
}
