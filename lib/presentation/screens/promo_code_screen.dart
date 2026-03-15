import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../components/custom_app_bar.dart';

class PromoCodeScreen extends StatefulWidget {
  const PromoCodeScreen({super.key});

  @override
  State<PromoCodeScreen> createState() => _PromoCodeScreenState();
}

class _PromoCodeScreenState extends State<PromoCodeScreen> {
  final TextEditingController promoController = TextEditingController();
  bool isError = false;

  void _activatePromo() {
    if (promoController.text == 'G17N160') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Промокод активирован!')),
      );
    } else {
      setState(() {
        isError = true;
      });
    }
  }

  void _retry() {
    setState(() {
      isError = false;
      promoController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.phoneScreenBg),
        child: SafeArea(
          child: Column(
            children: [
              // Аппбар и блок с полем ввода — внутри Padding
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      CustomAppBar(title: 'Промокоды'),
                      const SizedBox(height: 32),

                      Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Color(0xFF141530),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'У вас есть промокод?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height:24),
                            const Text(
                              'Введите промокод и получите скидку на поездку',
                              style: TextStyle(
                                color: AppColors.white70,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: promoController,
                              style: TextStyle(
                                color: isError ? Colors.red : Colors.white,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Введите промокод',
                                hintStyle: const TextStyle(color: AppColors.white70),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide(color: AppColors.smsDigit, width: 1.5),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      side: BorderSide(color: AppColors.white70.withOpacity(0.4)),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    child: const Text(
                                      'Отмена',
                                      style: TextStyle(color: AppColors.white70),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 22),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _activatePromo,
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      backgroundColor: AppColors.activeButtonGradient.colors[0],
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    child: const Text(
                                      'Активировать',
                                      style: TextStyle(color: AppColors.activeButtonText),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),
                    ],
                  ),
                ),
              ),

              // Нижняя картинка — без падинга, на всю ширину
              Image.asset(
                isError
                    ? 'assets/error_promo.png'
                    : 'assets/promo_bottom.png',
                width: double.infinity,
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}