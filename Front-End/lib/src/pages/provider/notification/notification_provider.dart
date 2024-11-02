import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier {
  String _otp = '';
  String _reservationId = '';
  bool _isVisible = false;
  int _currentSection = 0;
  int _timerValue = 0;
  double _amount = 0.0;
  final List<String> _notifications = [];
  bool _isTimerActive = false;
  String _paymentMethod = 'cash';
  String _paymentStatus = 'pending';

  // Getters
  String get otp => _otp;
  String get reservationId => _reservationId;
  bool get isVisible => _isVisible;
  int get currentSection => _currentSection;
  int get timerValue => _timerValue;
  double get amount => _amount;
  List<String> get notifications => _notifications;
  bool get isTimerActive => _isTimerActive;
  String get paymentMethod => _paymentMethod;
  String get paymentStatus => _paymentStatus;

  // Initialize service
  void initializeService(String otp, String reservationId) {
    _otp = otp;
    _reservationId = reservationId;
    _isVisible = true;
    _currentSection = 0;
    _timerValue = 0;
    _amount = 0.0;
    _isTimerActive = false;
    _paymentStatus = 'pending';
    notifyListeners();
  }

  // OTP Management
  void setOtp(String newOtp) {
    if (newOtp.isEmpty) return;
    _otp = newOtp;
    _isVisible = true;
    notifyListeners();
  }

  // Reservation Management
  void setReservationId(String id) {
    if (id.isEmpty) return;
    _reservationId = id;
    notifyListeners();
  }

  // Section Management
  void setSection(int section) {
    if (section < 0 || section > 2) return;
    _currentSection = section;
    notifyListeners();
  }

  // Timer Management
  void updateTimer(int value) {
    if (value < 0) return;
    _timerValue = value;
    _isTimerActive = true;
    notifyListeners();
  }

  void stopTimer() {
    _isTimerActive = false;
    notifyListeners();
  }

  // Payment Management
  void setAmount(double newAmount) {
    if (newAmount < 0) return;
    _amount = newAmount;
    notifyListeners();
  }

  void updatePayment({
    required String method,
    required String status,
    required double amount,
  }) {
    _paymentMethod = method;
    _paymentStatus = status;
    _amount = amount;
    notifyListeners();
  }

  // Notification Management
  void addNotification(String notification) {
    if (notification.isEmpty) return;
    _notifications.add(notification);
    notifyListeners();
  }

  void removeNotification(int index) {
    if (index < 0 || index >= _notifications.length) return;
    _notifications.removeAt(index);
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  // Reset state
  void reset() {
    _otp = '';
    _reservationId = '';
    _isVisible = false;
    _currentSection = 0;
    _timerValue = 0;
    _amount = 0.0;
    _isTimerActive = false;
    _paymentMethod = 'cash';
    _paymentStatus = 'pending';
    _notifications.clear();
    notifyListeners();
  }
}
