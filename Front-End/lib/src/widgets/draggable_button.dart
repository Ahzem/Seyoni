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
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    // Listen for OTP notifications
    Provider.of<NotificationProvider>(context, listen: false)
        .addListener(_onNotificationReceived);
  }

  void _onNotificationReceived() {
    setState(() {
      isVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final otp = Provider.of<NotificationProvider>(context).otp;
    if (!isVisible) return SizedBox.shrink();

    return Stack(
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
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: EdgeInsets.all(0),
                    child: Container(
                      width: 300,
                      height: 500,
                      color: Colors.white,
                      child: Center(child: Text('Your OTP is $otp')),
                    ),
                  );
                },
              );
            },
            child: FloatingActionButton(
              onPressed: null,
              backgroundColor: kPrimaryColor,
              child: Icon(Icons.lock),
            ),
          ),
        ),
      ],
    );
  }
}
