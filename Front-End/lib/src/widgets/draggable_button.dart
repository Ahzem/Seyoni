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
  Timer? _timer;
  bool _isDialogOpen = false;
  Timer? _debounceTimer;
  bool _dialogVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
          Provider.of<NotificationProvider>(context, listen: false);
      provider.addListener(_onProviderUpdate);
    });
  }

  @override
  void dispose() {
    _stopTimer();
    _debounceTimer?.cancel();
    Provider.of<NotificationProvider>(context, listen: false)
        .removeListener(_onProviderUpdate);
    super.dispose();
  }

  void _onProviderUpdate() {
    if (!mounted) return;

    final provider = Provider.of<NotificationProvider>(context, listen: false);
    if (provider.isTimerActive && provider.currentSection == 1) {
      _startTimer();
    } else {
      _stopTimer();
    }

    if (_dialogVisible) {
      _updateDialog();
    }
  }

  void _startTimer() {
    if (_timer != null) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      final provider =
          Provider.of<NotificationProvider>(context, listen: false);
      if (provider.isTimerActive && provider.currentSection == 1) {
        // Debounce the WebSocket messages
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 500), () {
          provider.updateTimer(provider.timerValue + 1);
        });
      } else {
        _stopTimer();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    _debounceTimer?.cancel();
  }

  void _updateDialog() {
    if (!mounted) return;
    Navigator.of(context).pop();
    _showDialog();
  }

  void _showDialog() {
    _isDialogOpen = true;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => WillPopScope(
        onWillPop: () async {
          _isDialogOpen = false;
          return true;
        },
        child: _buildDialog(),
      ),
    ).then((_) {
      _isDialogOpen = false;
      // Don't stop timer when dialog closes
    });
  }

  Widget _buildDialog() {
    return Consumer<NotificationProvider>(
      builder: (context, provider, _) {
        // Start timer if needed when dialog opens
        if (provider.isTimerActive &&
            provider.currentSection == 1 &&
            !_isDialogOpen) {
          _startTimer();
        }
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.5,
              color: kPrimaryColor,
              child: Center(
                child: _buildDialogContent(provider),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogContent(NotificationProvider provider) {
    switch (provider.currentSection) {
      case 0:
        return _buildOtpSection(provider);
      case 1:
        return _buildTimerSection(provider);
      case 2:
        return _buildPaymentSection(provider);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildOtpSection(NotificationProvider provider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Your OTP is', style: TextStyle(color: Colors.black)),
        const SizedBox(height: 20),
        Text(
          provider.otp,
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            letterSpacing: 10,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 30),
        const Text(
          'Please show this to the service provider',
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTimerSection(NotificationProvider provider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Timer', style: TextStyle(color: Colors.black)),
        const SizedBox(height: 20),
        Text(
          _formatTime(provider.timerValue),
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 30),
        const Text(
          'Please wait for the service provider',
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPaymentSection(NotificationProvider provider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Amount', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 20),
        Text(
          'Rs ${provider.amount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _handlePayment('cash', provider.amount),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child:
                  const Text('Pay Cash', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () => _handlePayment('card', provider.amount),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child:
                  const Text('Pay Card', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _handlePayment(String paymentMethod, double amount) async {
    final provider = Provider.of<NotificationProvider>(context, listen: false);
    try {
      final response = await http.patch(
        Uri.parse('$url/api/reservations/${provider.reservationId}/payment'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'paymentMethod': paymentMethod,
          'paymentStatus': 'paid',
          'amount': amount,
        }),
      );

      if (response.statusCode == 200 && mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment processed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error processing payment: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to process payment'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, provider, _) {
        if (!provider.isVisible || provider.otp.isEmpty) {
          return const SizedBox.shrink();
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
                      const buttonWidth = 56.0;
                      const buttonHeight = 56.0;

                      posX = posX < screenWidth / 2
                          ? 0
                          : screenWidth - buttonWidth;
                      posY = posY.clamp(0.0, screenHeight - buttonHeight);
                    });
                  },
                  onTap: _showDialog,
                  child: Opacity(
                    opacity: 0.8,
                    child: CircleAvatar(
                      radius: 28,
                      backgroundImage:
                          const AssetImage('assets/images/profile-3.jpg'),
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
      },
    );
  }

  String _formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$secs';
  }
}
