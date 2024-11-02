// // web_socket_service.dart
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:seyoni/src/config/url.dart';
// import 'package:seyoni/src/pages/provider/notification/notification_provider.dart';
// import 'package:web_socket_channel/io.dart';

// class WebSocketServiceForProvider {
//   static final WebSocketServiceForProvider _instance =
//       WebSocketServiceForProvider._internal();
//   factory WebSocketServiceForProvider() => _instance;
//   WebSocketServiceForProvider._internal();

//   late IOWebSocketChannel _channel;

//   void connect(String providerId) {
//     _channel = IOWebSocketChannel.connect(
//       'ws://$url?userType=provider&userId=$providerId',
//     );
//   }

//   void sendOTP(String otp, String seekerId) {
//     _channel.sink.add(jsonEncode({
//       'type': 'send_otp',
//       'otp': otp,
//       'seekerId': seekerId,
//     }));
//   }

//   void dispose() {
//     _channel.sink.close();
//   }
// }


// class WebSocketServiceForSeeker {
//   static final WebSocketServiceForSeeker _instance = WebSocketServiceForSeeker._internal();
//   factory WebSocketServiceForSeeker() => _instance;
//   WebSocketServiceForSeeker._internal();

//   late IOWebSocketChannel _channel;

//   void connect(String seekerId, BuildContext context) {
//     _channel = IOWebSocketChannel.connect(
//       'ws://$url?userType=seeker&userId=$seekerId',
//     );

//     _channel.stream.listen((message) {
//       final data = jsonDecode(message);
//       if (data['type'] == 'otp') {
//         final otp = data['otp'];
//         // Update the NotificationProvider
//         Provider.of<NotificationProvider>(context, listen: false)
//             .setOtp(otp);
//       }
//     });
//   }

//   void dispose() {
//     _channel.sink.close();
//   }
// }


// lib/src/services/websocket_service.dart
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  WebSocketChannel? _channel;

  factory WebSocketService() {
    return _instance;
  }

  WebSocketService._internal();

  void connect() {
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://seyoni.onrender.com'), // Update with your WebSocket URL
    );
  }

  void sendMessage(Map<String, dynamic> message) {
    _channel?.sink.add(jsonEncode(message));
  }

  Stream get stream => _channel!.stream;

  void dispose() {
    _channel?.sink.close();
  }
}