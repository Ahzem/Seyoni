import 'package:flutter/material.dart';
import '../../../../constants/constants_color.dart';

class BadgeWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color textColor;

  const BadgeWidget({
    super.key,
    required this.icon,
    required this.label,
    this.textColor = Colors.white, // Default text color to white
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Column(
            children: [
              Icon(icon, size: 40, color: kPrimaryColor),
              SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(color: textColor, fontSize: 12),
              ),
            ],
          ), // Assuming icon color is white
        ],
      ),
    );
  }
}
