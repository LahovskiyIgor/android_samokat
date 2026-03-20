import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_colors.dart';
import '../components/custom_app_bar.dart';
import '../components/gradient_button.dart';

class PaymentConfirmScreen extends StatelessWidget {
  const PaymentConfirmScreen({super.key});

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
                child: CustomAppBar(title: 'Оплата'),
              ),

              const SizedBox(height: 40),

              // 🔹 ЦЕНТРАЛЬНАЯ КНОПКА
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: GradientButton(
                      text: 'Оплатить',
                      showArrows: true,
                      height: 56,
                      width: double.infinity,
                      fontSize: 16,
                      onTap: () {
                        // TODO: Логика оплаты
                        // После успешной оплаты переходим на главный экран или в профиль
                        context.go('/home');
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