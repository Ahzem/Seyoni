import 'package:flutter/material.dart';
import '../../../constants/constants_color.dart';
import '../../../constants/constants_font.dart';

class MenuItem extends StatelessWidget {
  final String iconPath;
  final String text;
  final VoidCallback onPressed;

  const MenuItem({
    required this.iconPath,
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.05),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Image.asset(
                  iconPath,
                  height: 30,
                  width: 30,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                text,
                style: kMenuItemTextStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              color: kBackgroundColor,
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }
}
