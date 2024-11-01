import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier {
  String _otp = '';
  final List<String> _notifications = [];

  String get otp => _otp;

  List<String> get notifications => _notifications;

  void setOtp(String newOtp) {
    _otp = newOtp;
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