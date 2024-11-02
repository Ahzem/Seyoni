import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier {
  String _otp = '';
  String _reservationId = '';
  bool _isVisible = false;
  int _currentSection = 0;
  int _timerValue = 0;
  double _amount = 0.0;
  final List<String> _notifications = [];

  String get otp => _otp;
  String get reservationId => _reservationId;
  bool get isVisible => _isVisible;
  int get currentSection => _currentSection;
  int get timerValue => _timerValue;
  double get amount => _amount;
  List<String> get notifications => _notifications;

  void setOtp(String newOtp) {
    _otp = newOtp;
    _isVisible = true;
    notifyListeners();
  }

  void setReservationId(String id) {
    _reservationId = id;
    notifyListeners();
  }

  void setSection(int section) {
    _currentSection = section;
    notifyListeners();
  }

  void updateTimer(int value) {
    _timerValue = value;
    notifyListeners();
  }

  void setAmount(double newAmount) {
    _amount = newAmount;
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
