// websocket_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:seyoni/src/config/url.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  IOWebSocketChannel? _channel;
  bool _isConnected = false;
  bool _isConnecting = false;
  final List<Function(dynamic)> _messageListeners = [];
  Timer? _reconnectTimer;
  Timer? _pingTimer;
  int _reconnectAttempts = 0;
  static const int maxReconnectAttempts = 5;

  factory WebSocketService() {
    return _instance;
  }

  WebSocketService._internal();

  Future<void> connect() async {
    if (_isConnected || _isConnecting) return;
    _isConnecting = true;

    try {
      debugPrint('Connecting to WebSocket: $wsUrl');

      final socket = await WebSocket.connect(
        wsUrl,
        headers: {
          'Origin': 'https://seyoni.onrender.com',
          'Connection': 'Upgrade',
          'Upgrade': 'websocket',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Connection timeout');
        },
      );

      _channel = IOWebSocketChannel(socket);
      _setupPingPong();
      _setupMessageListener();

      _isConnected = true;
      _isConnecting = false;
      _reconnectAttempts = 0;

      debugPrint('WebSocket connected successfully');
    } catch (e, stackTrace) {
      debugPrint('WebSocket Connection Error: $e');
      debugPrint('Stack trace: $stackTrace');
      _handleDisconnect('Connection error: $e');
    }
  }

  void _setupPingPong() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_isConnected) {
        try {
          _channel?.sink.add('ping');
        } catch (e) {
          debugPrint('Error sending ping: $e');
          _handleDisconnect('Ping failed');
        }
      }
    });
  }

  void _setupMessageListener() {
    _channel?.stream.listen(
      (message) {
        if (message == 'pong') return;
        try {
          debugPrint('WebSocket received: $message');
          for (var listener in _messageListeners) {
            listener(message);
          }
        } catch (e) {
          debugPrint('Error processing message: $e');
        }
      },
      onError: (error) {
        debugPrint('WebSocket Error: $error');
        _handleDisconnect('Stream error: $error');
      },
      onDone: () {
        debugPrint('WebSocket connection closed');
        _handleDisconnect('Connection closed');
      },
      cancelOnError: false,
    );
  }

  void _handleDisconnect(String reason) {
    debugPrint('Disconnected: $reason');
    _isConnected = false;
    _isConnecting = false;
    _pingTimer?.cancel();

    if (_reconnectAttempts < maxReconnectAttempts) {
      _reconnectAttempts++;
      int delaySeconds = _reconnectAttempts * 5;

      _reconnectTimer?.cancel();
      _reconnectTimer = Timer(Duration(seconds: delaySeconds), () {
        debugPrint('Attempting to reconnect (attempt $_reconnectAttempts)...');
        connect();
      });
    } else {
      debugPrint('Max reconnection attempts reached');
      Timer(const Duration(minutes: 1), () {
        _reconnectAttempts = 0;
        connect();
      });
    }
  }

  void addMessageListener(Function(dynamic) listener) {
    if (!_messageListeners.contains(listener)) {
      _messageListeners.add(listener);
    }
  }

  void removeMessageListener(Function(dynamic) listener) {
    _messageListeners.remove(listener);
  }

  Future<void> sendMessage(Map<String, dynamic> message) async {
    if (!_isConnected) {
      await connect();
      await Future.delayed(const Duration(seconds: 2));
    }

    if (_isConnected && _channel != null) {
      try {
        final jsonMessage = jsonEncode(message);
        debugPrint('Sending WebSocket message: $jsonMessage');
        _channel!.sink.add(jsonMessage);
      } catch (e) {
        debugPrint('Error sending message: $e');
        _handleDisconnect('Send message failed: $e');
      }
    } else {
      debugPrint('WebSocket not connected. Message not sent.');
    }
  }

  bool get isConnected => _isConnected;

  void dispose() {
    _reconnectTimer?.cancel();
    _pingTimer?.cancel();
    _messageListeners.clear();
    _channel?.sink.close(status.normalClosure, 'Disposed');
    _isConnected = false;
    _isConnecting = false;
  }
}
