import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/app_colors.dart';
import '../components/custom_app_bar.dart';
import '../components/link_row.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

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
                CustomAppBar(title: 'Документы'),
                const SizedBox(height: 32),

                // Список ссылок
                LinkRow(
                  icon: 'assets/icons/doc.png',
                  title: 'Договор аренды',
                  onTap: () => openLink('https://...'),
                ),
                const Divider(height: 1, color: Colors.white24),
                const SizedBox(height: 12),
                LinkRow(
                  icon: 'assets/icons/doc.png',
                  title: 'Политика конфиденциальности',
                  onTap: () => openLink('https://...'),
                ),
                const Divider(height: 1, color: Colors.white24),
                const SizedBox(height: 12),
                LinkRow(
                  icon: 'assets/icons/doc.png',
                  title: 'Правила вождения',
                  onTap: () => openLink('https://...'),
                ),
                const Divider(height: 1, color: Colors.white24),
                const SizedBox(height: 12),
                LinkRow(
                  icon: 'assets/icons/doc.png',
                  title: 'Правила оплаты картой',
                  onTap: () => openLink('https://...'),
                ),
                const Divider(height: 1, color: Colors.white24),
                const SizedBox(height: 12),

                const Spacer(), // Отодвигаем картинку вниз


                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}