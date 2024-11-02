import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:seyoni/src/config/url.dart';
import 'package:seyoni/src/constants/constants_color.dart';
import 'package:seyoni/src/pages/provider/notification/notification_provider.dart';

class DraggableOtpButton extends StatefulWidget {
  const DraggableOtpButton({super.key});

  @override
  DraggableOtpButtonState createState() => DraggableOtpButtonState();
}

class DraggableOtpButtonState extends State<DraggableOtpButton> {
  double posX = 100;
  double posY = 100;
  bool isVisible = false;
  ValueNotifier<int> remainingTimeNotifier = ValueNotifier<int>(0);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(context, listen: false)
          .addListener(_onNotificationReceived);
    });
  }

  @override
  void dispose() {
    Provider.of<NotificationProvider>(context, listen: false)
        .removeListener(_onNotificationReceived);
    _timer?.cancel();
    super.dispose();
  }

  void _onNotificationReceived() {
    if (mounted) {
      setState(() {
        isVisible = true;
      });
    }
  }

  void startTimer() {
    if (_timer == null || !_timer!.isActive) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        remainingTimeNotifier.value++;
      });
    }
  }

  void stopTimer() {
    _timer?.cancel();
  }

  Future<void> _handlePayment(
      String paymentMethod, double amount, BuildContext context) async {
    final reservationId =
        Provider.of<NotificationProvider>(context, listen: false).reservationId;

    try {
      final response = await http.patch(
        Uri.parse('$url/api/reservations/$reservationId/payment'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'paymentMethod': paymentMethod,
          'paymentStatus': 'paid',
          'amount': amount,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pop(); // Close dialog
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment processed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error processing payment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to process payment'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
      // Only show when provider has OTP and is visible
      if (!notificationProvider.isVisible || notificationProvider.otp.isEmpty) {
        return SizedBox.shrink();
      }
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              left: posX,
              top: posY,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    posX += details.delta.dx;
                    posY += details.delta.dy;
                  });
                },
                onPanEnd: (details) {
                  setState(() {
                    final screenWidth = MediaQuery.of(context).size.width;
                    final screenHeight = MediaQuery.of(context).size.height;
                    final buttonWidth =
                        56.0; // Width of the FloatingActionButton
                    final buttonHeight =
                        56.0; // Height of the FloatingActionButton

                    // Calculate the nearest edge
                    if (posX < screenWidth / 2) {
                      posX = 0; // Stick to the left edge
                    } else {
                      posX =
                          screenWidth - buttonWidth; // Stick to the right edge
                    }

                    if (posY < 0) {
                      posY = 0; // Stick to the top edge
                    } else if (posY > screenHeight - buttonHeight) {
                      posY = screenHeight -
                          buttonHeight; // Stick to the bottom edge
                    }
                  });
                },
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: EdgeInsets.all(0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.6,
                            color: kPrimaryColor,
                            child: Center(
                              child: Consumer<NotificationProvider>(
                                builder: (context, provider, child) {
                                  if (provider.currentSection == 0) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Your OTP is'),
                                        SizedBox(height: 20),
                                        Text(
                                          provider.otp,
                                          style: TextStyle(
                                            fontSize: 48,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 10,
                                          ),
                                        ),
                                      ],
                                    );
                                  } else if (provider.currentSection == 1) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Timer'),
                                        SizedBox(height: 20),
                                        Text(
                                          _formatTime(provider.timerValue),
                                          style: TextStyle(
                                            fontSize: 48,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Amount',
                                            style: TextStyle(
                                                fontSize: 24,
                                                color: Colors.white)),
                                        SizedBox(height: 20),
                                        Text(
                                          'Rs ${provider.amount.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 48,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 30),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () => _handlePayment(
                                                  'cash',
                                                  provider.amount,
                                                  context),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 30,
                                                    vertical: 15),
                                              ),
                                              child: Text('Pay Cash',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                            SizedBox(width: 20),
                                            ElevatedButton(
                                              onPressed: () => _handlePayment(
                                                  'card',
                                                  provider.amount,
                                                  context),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 30,
                                                    vertical: 15),
                                              ),
                                              child: Text('Pay Card',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Opacity(
                  opacity: 0.8,
                  child: CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage('assets/images/profile-3.jpg'),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: kPrimaryColor,
                          width: 3.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  String _formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$secs';
  }
}
