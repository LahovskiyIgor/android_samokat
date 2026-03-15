import 'package:flutter/material.dart';

import '../components/gradient_button.dart';
import '../../core/app_colors.dart';

class BlockedScreen extends StatelessWidget {
  const BlockedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.phoneScreenBg,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Аккаунт заблокирован",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),

              const SizedBox(height: 40),
              Image.asset(
                'assets/ban.png',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 40),

              GradientButton(
                text: "Обратиться в техподдержку",
                onTap: () {},
                showArrows: true,
                height: 50,
                width: 290,
                fontSize: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}