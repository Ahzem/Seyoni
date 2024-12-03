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
  final List<Map<String, dynamic>> _messageQueue = [];

  factory WebSocketService() {
    return _instance;
  }

  WebSocketService._internal();

  // websocket_service.dart
  Future<void> connect() async {
    if (_isConnected || _isConnecting) return;
    _isConnecting = true;

    try {
      debugPrint('Connecting to WebSocket: $wsUrl');

      final socket = await WebSocket.connect(
        wsUrl,
        headers: {
          'Origin': url,
          'Connection': 'Upgrade',
          'Upgrade': 'websocket',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Connection timeout'),
      );

      _channel = IOWebSocketChannel(socket);
      _isConnected = true;
      _isConnecting = false;
      _reconnectAttempts = 0;

      debugPrint('WebSocket connected successfully');

      // Process queued messages immediately after connection
      _setupMessageListener();
      _setupPingPong();
      _processMessageQueue();
    } catch (e) {
      debugPrint('WebSocket connection error: $e');
      _handleDisconnect('Connection failed: $e');
      rethrow; // Propagate error for proper handling
    }
  }

  Future<void> sendMessage(Map<String, dynamic> message) async {
    if (!_isConnected) {
      debugPrint('WebSocket not connected, queuing message: $message');
      _messageQueue.add(message);
      await connect();
      return;
    }

    try {
      final jsonMessage = jsonEncode(message);
      debugPrint('Sending WebSocket message: $jsonMessage');
      _channel?.sink.add(jsonMessage);
    } catch (e) {
      debugPrint('Error sending message: $e');
      _messageQueue.add(message);
      _handleDisconnect('Send message failed: $e');
    }
  }

  void _processMessageQueue() {
    while (_messageQueue.isNotEmpty && _isConnected) {
      final message = _messageQueue.removeAt(0);
      sendMessage(message);
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

          // Parse message if it's a string
          dynamic parsedMessage = message;
          if (message is String) {
            try {
              parsedMessage = json.decode(message);
            } catch (e) {
              debugPrint('Error parsing message: $e');
              return;
            }
          }

          // Notify listeners with parsed message
          for (var listener in _messageListeners) {
            listener(parsedMessage);
          }
        } catch (e) {
          debugPrint('Error processing message: $e');
        }
      },
      onError: (error) {
        debugPrint('WebSocket error: $error');
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
      final delaySeconds = _reconnectAttempts * 2; // Exponential backoff

      debugPrint(
          'Attempting reconnection $_reconnectAttempts of $maxReconnectAttempts in ${delaySeconds}s');

      _reconnectTimer?.cancel();
      _reconnectTimer = Timer(Duration(seconds: delaySeconds), () {
        connect().catchError((e) {
          debugPrint('Reconnection attempt failed: $e');
        });
      });
    } else {
      debugPrint(
          'Max reconnection attempts reached. Manual reconnection required.');
      // Reset attempts after 1 minute
      Timer(const Duration(minutes: 1), () {
        _reconnectAttempts = 0;
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
