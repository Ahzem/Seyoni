import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier {
  String _otp = '';
  final List<String> _notifications = [];

  String get otp => _otp;

  List<String> get notifications => _notifications;

  void setOtp(String otp) {
    _otp = otp;
    notifyListeners();
  }

  void addNotification(String notification) {
    _notifications.add(notification);
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }
}