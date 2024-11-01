import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  bool isVisible = true;
  int _currentSection = 0;
  // int _remainingTime = 0;
  ValueNotifier<int> _remainingTimeNotifier = ValueNotifier<int>(0);
  int _elapsedTime = 0;
  Timer? _timer;
  bool _isDialogOpen = false;

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

  // void _startTimer() {
  //   if (_timer == null || !_timer!.isActive) {
  //     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //       setState(() {
  //         _remainingTime++;
  //       });
  //     });
  //   }
  // }

  void _startTimer() {
    if (_timer == null || !_timer!.isActive) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _remainingTimeNotifier.value++;
      });
    }
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final otp = Provider.of<NotificationProvider>(context).otp;
    if (!isVisible) return SizedBox.shrink();
    return Container(
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
                  final buttonWidth = 56.0; // Width of the FloatingActionButton
                  final buttonHeight =
                      56.0; // Height of the FloatingActionButton

                  // Calculate the nearest edge
                  if (posX < screenWidth / 2) {
                    posX = 0; // Stick to the left edge
                  } else {
                    posX = screenWidth - buttonWidth; // Stick to the right edge
                  }

                  if (posY < 0) {
                    posY = 0; // Stick to the top edge
                  } else if (posY > screenHeight - buttonHeight) {
                    posY =
                        screenHeight - buttonHeight; // Stick to the bottom edge
                  }
                });
              },
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible:
                      true, // Allow dismissing by tapping outside
                  builder: (BuildContext context) {
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      insetPadding: EdgeInsets.all(0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.6,
                              color: kPrimaryColor,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_currentSection == 0) ...[
                                      Text(
                                        'Your OTP is',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        // otp,
                                        '123456',
                                        style: TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 10,
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _currentSection = 1;
                                            _startTimer();
                                          });
                                        },
                                        child: Text('Next'),
                                      ),
                                    ] else if (_currentSection == 1) ...[
                                      Text(
                                        'Timer',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(height: 20),
                                      ValueListenableBuilder<int>(
                                        valueListenable: _remainingTimeNotifier,
                                        builder: (context, value, child) {
                                          return Text(
                                            _formatTime(value),
                                            style: TextStyle(
                                              fontSize: 48,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Handle emergency
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        child: Text('Emergency'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _currentSection = 2;
                                            _stopTimer();
                                            _elapsedTime =
                                                _remainingTimeNotifier.value;
                                          });
                                          // Navigator.of(context)
                                          //     .pop(); // Close the dialog
                                        },
                                        child: Text('Finish'),
                                      ),
                                      SizedBox(height: 10),
                                    ] else if (_currentSection == 2) ...[
                                      Text(
                                        'Service Time: ${_formatTime(_elapsedTime)}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Rs 100.00', // Replace with actual amount
                                        style: TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          DropdownButton<String>(
                                            value: 'Card',
                                            items: <String>['Card', 'Cash']
                                                .map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              // Handle payment method change
                                            },
                                          ),
                                          SizedBox(width: 20),
                                          ElevatedButton(
                                            onPressed: () {
                                              _stopTimer(); // Stop the timer when done
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            },
                                            child: Text('Pay'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ).then((_) {
                  // Do nothing here to keep the timer running
                  _isDialogOpen = false;
                });
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
  }

  String _formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$secs';
  }
}
