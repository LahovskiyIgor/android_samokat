import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // ✅ Добавлен

class LinkRow extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;

  const LinkRow({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Image.asset(
              icon,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            Row(
              children: [
                Icon(Icons.arrow_forward_ios_sharp, color: const Color(0x99FFFFFF), size: 12),
                Icon(Icons.arrow_forward_ios_sharp, color: const Color(0x66FFFFFF), size: 12),
                Icon(Icons.arrow_forward_ios_sharp, color: const Color(0x33FFFFFF), size: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ Выносим метод открытия ссылки
void openLink(String url) async {
  final Uri uri = Uri.parse(url);

  try {
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  } catch (e) {
    // TODO: Показать ошибку пользователю
    print('Не удалось открыть ссылку: $e');
  }
}