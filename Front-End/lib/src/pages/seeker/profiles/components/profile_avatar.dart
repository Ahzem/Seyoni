import 'package:flutter/material.dart';
import 'package:seyoni/src/constants/constants_color.dart';

class ProfileAvatar extends StatelessWidget {
  final String imagePath;
  final bool isOnline;
  final ImageProvider imageProvider;

  const ProfileAvatar(
      {super.key,
      required this.imagePath,
      required this.isOnline,
      required this.imageProvider});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            backgroundBlendMode: BlendMode.darken,
            color: Colors.transparent,
            border: Border.all(color: kPrimaryColor.withOpacity(0.8), width: 1),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: kPrimaryColor.withOpacity(0.8),
                spreadRadius: 1,
                blurRadius: 20,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundImage: imageProvider, // Profile image
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color:
                  isOnline ? Colors.green : Colors.red, // Online/Offline status
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
