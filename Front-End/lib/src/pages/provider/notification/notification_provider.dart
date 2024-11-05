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
  String _currentSeekerId = '';
  DateTime? _lastMessageTime;
  static const _minMessageInterval = Duration(seconds: 1);
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
  String get currentSeekerId => _currentSeekerId;

  NotificationProvider() {
    _initializeWebSocket();
  }

// Add reidentification after reconnection
  void _initializeWebSocket() {
    _webSocket.connect();
    _webSocket.addMessageListener(_handleWebSocketMessage);

    // Re-identify after reconnection
    if (_currentSeekerId.isNotEmpty) {
      _webSocket.sendMessage({
        'type': 'identify',
        'userId': _currentSeekerId,
        'userType': 'seeker'
      });
    }
  }

  // Add this method to expose WebSocket functionality
  Future<void> sendMessage(Map<String, dynamic> message) async {
    await _webSocket.sendMessage(message);
  }

  Future<void> identifyUser(String userId, String userType) async {
    debugPrint('Identifying user - ID: $userId, Type: $userType');
    _currentSeekerId = userId;
    await ensureConnection();
    await _webSocket.sendMessage(
        {'type': 'identify', 'userId': userId, 'userType': userType});
    debugPrint('User identified with seekerId: $_currentSeekerId');
  }

  Future<void> ensureConnection() async {
    if (!_webSocket.isConnected) {
      debugPrint('WebSocket not connected, establishing connection...');
      await _webSocket.connect();
      // Add small delay to ensure connection is ready
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  void _handleWebSocketMessage(dynamic message) {
    try {
      debugPrint('Raw WebSocket message received: $message');

      Map<String, dynamic> data;
      if (message is String) {
        data = json.decode(message);
      } else {
        data = message as Map<String, dynamic>;
      }

      if (data['type'] == 'otp_update') {
        final targetSeekerId = data['seekerId'];
        debugPrint(
            'OTP Update received - Target: $targetSeekerId, Current: $_currentSeekerId');

        if (targetSeekerId == _currentSeekerId) {
          setState(() {
            _otp = data['otp'];
            _reservationId = data['reservationId'];
            _isVisible = true;
            _currentSection = 0;
            debugPrint('Updated OTP state - OTP: $_otp, Visible: $_isVisible');
          });
          notifyListeners();
        }
      }

      // Handle other message types
      switch (data['type']) {
        case 'section_update':
          _handleSectionUpdate(data);
          break;
        case 'timer_update':
          _handleTimerUpdate(data);
          break;
        case 'payment_update':
          _handlePaymentUpdate(data);
          break;
        case 'timer_status_update':
          _handleTimerStatusUpdate(data);
          break;
      }
    } catch (e) {
      debugPrint('Error handling WebSocket message: $e');
    }
  }

  // Add helper method to batch state updates
  void setState(VoidCallback fn) {
    try {
      fn();
      debugPrint('Notifying listeners after state update');
      notifyListeners();
    } catch (e) {
      debugPrint('Error in setState: $e');
    }
  }

  void _handleSectionUpdate(Map<String, dynamic> data) {
    setSection(data['section']);
  }

  void _handleTimerUpdate(Map<String, dynamic> data) {
    updateTimer(data['value']);
  }

  void _handleTimerStatusUpdate(Map<String, dynamic> data) {
    setIsTimerActive(data['isActive']);
  }

  void _handlePaymentUpdate(Map<String, dynamic> data) {
    updatePayment(
      method: data['method'],
      status: data['status'],
      amount: data['amount'].toDouble(),
    );
  }

  Future<void> initializeService({
    required String otp,
    required String reservationId,
    required String seekerId,
  }) async {
    debugPrint('Initializing service with OTP: $otp for seeker: $seekerId');

    // Update local state first with setState to ensure notification
    setState(() {
      _otp = otp;
      _reservationId = reservationId;
      _currentSeekerId = seekerId;
      _isVisible = true; // Explicitly set to true
      _currentSection = 0;
    });

    try {
      await ensureConnection();

      final message = {
        'type': 'otp_update',
        'otp': otp,
        'reservationId': reservationId,
        'seekerId': seekerId,
      };

      await _webSocket.sendMessage(message);
      debugPrint('OTP message sent successfully');

      // Force another state update to ensure UI updates
      notifyListeners();
    } catch (e) {
      debugPrint('Error sending OTP: $e');
      // Even if send fails, keep local state visible
      notifyListeners();
    }
  }

  // Section Management
  void setSection(int section) {
    if (section < 0 || section > 2) return;
    if (_currentSection == section) return;

    _currentSection = section;
    _webSocket.sendMessage({
      'type': 'section_update',
      'section': section,
      'reservationId': _reservationId
    });
    // Force immediate notification
    notifyListeners();
  }

  // Timer Management
  void updateTimer(int value) {
    if (value < 0 || _timerValue == value) return;

    final now = DateTime.now();
    if (_lastMessageTime != null &&
        now.difference(_lastMessageTime!) < _minMessageInterval) {
      return;
    }

    _timerValue = value;
    _lastMessageTime = now;

    _webSocket.sendMessage({
      'type': 'timer_update',
      'value': value,
      'reservationId': _reservationId
    });

    notifyListeners();
  }

  void setIsTimerActive(bool value) {
    if (_isTimerActive == value) return;
    _isTimerActive = value;

    if (!value) {
      _timerValue = 0;
    }

    notifyListeners();
  }

  void startTimer() {
    setIsTimerActive(true);
    setSection(1);
  }

  void stopTimer() {
    setIsTimerActive(false);
    setSection(2);
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
    if (_amount == amount &&
        _paymentMethod == method &&
        _paymentStatus == status) {
      return;
    }

    _amount = amount;
    _paymentMethod = method;
    _paymentStatus = status;

    final now = DateTime.now();
    if (_lastMessageTime != null &&
        now.difference(_lastMessageTime!) < _minMessageInterval) {
      return;
    }

    _lastMessageTime = now;
    _webSocket.sendMessage({
      'type': 'payment_update',
      'method': method,
      'status': status,
      'amount': amount,
      'reservationId': _reservationId, // Include reservationId
    });
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
    _isTimerActive = false;
    _timerValue = 0;
    _webSocket.removeMessageListener(_handleWebSocketMessage);
    _webSocket.dispose();
    super.dispose();
  }
}
