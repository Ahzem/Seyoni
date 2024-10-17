import 'package:flutter/material.dart';

class StatWidget extends StatelessWidget {
  final String label;
  final String value;

  const StatWidget({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.05),
        border: const Border(
            bottom: BorderSide(
                color: Color.fromARGB(150, 255, 255, 255), width: 1)),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.white)),
        ],
      ),
    );
  }
}
