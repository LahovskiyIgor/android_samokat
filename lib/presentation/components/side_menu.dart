import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/onboarding_screen.dart';
import 'package:by_happy/presentation/screens/documents_screen.dart';
import 'package:by_happy/presentation/screens/promo_code_screen.dart';
import '../../core/app_colors.dart';
import '../screens/profile_screen.dart';
import '../screens/support_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.phoneScreenBg,
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Добро пожаловать!',
                        style: TextStyle(
                          color: AppColors.smsDigit,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '+375-00-000-00-00',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Баланс 0,00 руб.',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(color: Colors.white30, height: 1),

                // Пункты меню с возможностью скролла
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Пункты меню
                        Column(
                          children: [
                            _MenuItem(
                              icon: Icons.person_outline,
                              title: 'Профиль',
                              onTap: () => {
                                context.go('/home/profile'),
                              },
                            ),
                            _MenuItem(
                              icon: Icons.list,
                              title: 'История поездок',
                              onTap: () => Navigator.pop(context),
                            ),
                            const Divider(color: Colors.white30, height: 1),
                            _MenuItem(
                              icon: Icons.credit_card,
                              title: 'Способ оплаты',
                              onTap: () => context.go("/home/payment-methods"),
                            ),
                            _MenuItem(
                              icon: Icons.question_mark_sharp,
                              title: 'Промокоды',
                              onTap: () => context.go("/home/promo"),
                            ),
                            _MenuItem(
                              icon: Icons.question_mark_sharp,
                              title: 'Абонементы',
                              onTap: () => Navigator.pop(context),
                            ),
                            const Divider(color: Colors.white30, height: 1),
                            _MenuItem(
                              icon: Icons.headphones_rounded,
                              title: 'Правила пользования самокатом',
                              onTap: () => context.go("/home/rules")
                            ),
                            _MenuItem(
                              icon: Icons.headphones_rounded,
                              title: 'Техподдержка',
                              onTap: () => {
                                context.go('/home/support'),
                              },
                            ),
                            _MenuItem(
                              icon: Icons.my_library_books_outlined,
                              title: 'Документы',
                              onTap: () => context.go("/home/documents"),
                            ),
                            _MenuItem(
                              icon: Icons.newspaper_sharp,
                              title: 'Новости',
                              onTap: () => context.go("/home/news"),
                            ),
                            const Divider(color: Colors.white30, height: 1),
                            _MenuItem(
                              icon: Icons.logout_outlined,
                              title: 'Выход',
                              onTap: () => Navigator.pop(context),
                            ),
                            _MenuItem(
                              icon: Icons.my_library_books_outlined,
                              title: 'qr',
                              onTap: () => context.go("/home/qr"),
                            ),
                          ],
                        ),

                        // Картинка внизу (внутри скролла)
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Image.asset(
                            'assets/wave.png',
                            width: double.infinity,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? color;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.smsDigit,
        size: 28,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
    );
  }
}