import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

class ScooterInfoItem extends StatelessWidget {
  final String icon;
  final String text;

  const ScooterInfoItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Image.asset(
              icon,
            height: 20,
            width: 20,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}