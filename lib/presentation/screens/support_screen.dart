import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/app_colors.dart';
import '../components/custom_app_bar.dart';
import '../components/link_row.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.phoneScreenBg),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // ✅ Используем общий AppBar
                const SizedBox(height: 16),
                CustomAppBar(title: 'Техподдержка'),
                const SizedBox(height: 32),

                // Список ссылок
                LinkRow(
                  icon: 'assets/icons/telegram.png',
                  title: 'Telegram',
                  onTap: () => openLink('https://t.me/...'),
                ),
                const Divider(height: 1, color: Colors.white24),
                const SizedBox(height: 12),
                LinkRow(
                  icon: 'assets/icons/whatsapp.png',
                  title: 'WhatsApp',
                  onTap: () => openLink('https://wa.me/...'),
                ),
                const Divider(height: 1, color: Colors.white24),
                const SizedBox(height: 12),
                LinkRow(
                  icon: 'assets/icons/viber.png',
                  title: 'Viber',
                  onTap: () => openLink('viber://chat?number=...'),
                ),
                const Divider(height: 1, color: Colors.white24),
                const SizedBox(height: 12),
                LinkRow(
                  icon: 'assets/icons/call.png',
                  title: 'Позвонить',
                  onTap: () => openLink('tel:+375000000000'),
                ),
                const Divider(height: 1, color: Colors.white24),
                const SizedBox(height: 12),

                const Spacer(), // Отодвигаем картинку вниз

                // Нижняя картинка
                Image.asset(
                  'assets/support_bottom.png',
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
