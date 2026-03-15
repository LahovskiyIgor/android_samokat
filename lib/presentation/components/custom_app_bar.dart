import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.pop(context),
          child: Row(
            children: [
              Icon(Icons.arrow_back_ios_sharp, color: const Color(0x99FFFFFF), size: 20),
              Icon(Icons.arrow_back_ios_sharp, color: const Color(0x66FFFFFF), size: 20),
              Icon(Icons.arrow_back_ios_sharp, color: const Color(0x22FFFFFF), size: 20),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}