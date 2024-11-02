import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:seyoni/src/services/websocket_service.dart';

class NotificationProvider with ChangeNotifier {
  // Private fields
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
  final WebSocketService _webSocket = WebSocketService();

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

  NotificationProvider() {
    _initializeWebSocket();
  }

  void _initializeWebSocket() {
    _webSocket.connect();
    _webSocket.addMessageListener(_handleWebSocketMessage);
  }

  void _handleWebSocketMessage(dynamic message) {
    try {
      if (message is String) {
        final data = json.decode(message);
        switch (data['type']) {
          case 'otp_update':
            _handleOtpUpdate(data);
            break;
          case 'section_update':
            _handleSectionUpdate(data);
            break;
          case 'timer_update':
            _handleTimerUpdate(data);
            break;
          case 'payment_update':
            _handlePaymentUpdate(data);
            break;
        }
      }
    } catch (e) {
      debugPrint('Error handling WebSocket message: $e');
    }
  }

  void _handleOtpUpdate(Map<String, dynamic> data) {
    setOtp(data['otp']);
    setReservationId(data['reservationId']);
  }

  void _handleSectionUpdate(Map<String, dynamic> data) {
    setSection(data['section']);
  }

  void _handleTimerUpdate(Map<String, dynamic> data) {
    updateTimer(data['value']);
  }

  void _handlePaymentUpdate(Map<String, dynamic> data) {
    updatePayment(
      method: data['method'],
      status: data['status'],
      amount: data['amount'].toDouble(),
    );
  }

  // Service Initialization
  void initializeService(String otp, String reservationId) {
    _webSocket.sendMessage({
      'type': 'otp_update',
      'otp': otp,
      'reservationId': reservationId,
    });
    _otp = otp;
    _reservationId = reservationId;
    _isVisible = true;
    _currentSection = 0;
    notifyListeners();
  }

  // Section Management
  void setSection(int section) {
    if (section < 0 || section > 2) return;
    _webSocket.sendMessage({
      'type': 'section_update',
      'section': section,
    });
    _currentSection = section;
    notifyListeners();
  }

  // Timer Management
  void updateTimer(int value) {
    if (value < 0) return;
    _webSocket.sendMessage({
      'type': 'timer_update',
      'value': value,
    });
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
    _webSocket.sendMessage({
      'type': 'payment_update',
      'method': method,
      'status': status,
      'amount': amount,
    });
    _paymentMethod = method;
    _paymentStatus = status;
    _amount = amount;
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

  // State Management
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

  @override
  void dispose() {
    _webSocket.removeMessageListener(_handleWebSocketMessage);
    _webSocket.dispose();
    super.dispose();
  }
}
