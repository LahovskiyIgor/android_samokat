import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_colors.dart';
import '../components/custom_app_bar.dart';
import '../components/gradient_button.dart';

class SendPhotoScreen extends StatelessWidget {
  const SendPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.phoneScreenBg),
        child: SafeArea(
          child: Column(
            children: [
              // 🔹 HEADER
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomAppBar(title: 'Подтверждение'),
              ),

              const SizedBox(height: 40),

              // 🔹 ЦЕНТРАЛЬНАЯ КНОПКА
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: GradientButton(
                      text: 'Отправить фото',
                      showArrows: true,
                      height: 56,
                      width: double.infinity,
                      fontSize: 16,
                      onTap: () {
                        // TODO: Логика отправки фото
                        // После отправки переходим на экран оплаты
                        context.go('/home/confirm/payment');
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}