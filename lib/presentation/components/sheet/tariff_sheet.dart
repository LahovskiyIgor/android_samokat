import 'dart:ui';
import 'package:flutter/material.dart';

class TariffSheet extends StatelessWidget {
  const TariffSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 400,
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF000032).withOpacity(0.88),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Самокат 123-456',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 🔹 Тарифы: две карточки
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _TariffCard(
                      title: 'Поминутно',
                      price: '2 BYN',
                      subtitle: 'Старт поездки',
                      details: ['Далее 0.29 BYN/мин.', 'Минута на паузе 3 BYN'],
                      isActive: true,
                    ),
                    _TariffCard(
                      title: 'На 1 час',
                      price: '10 BYN',
                      subtitle: 'Далее 0.29 BYN/мин.',
                      details: [],
                      isActive: false,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 🔹 Кнопка "Способ оплаты"
                _GradientButton(
                  text: 'Способ оплаты',
                  showArrows: true,
                  height: 56,
                  width: double.infinity,
                  fontSize: 16,
                ),

                const SizedBox(height: 16),

                // 🔹 Кнопка "Забронировать"
                _GradientButton(
                  text: 'Забронировать',
                  showArrows: true,
                  height: 56,
                  width: double.infinity,
                  fontSize: 16,
                  gradientColors: const [Color(0xFF66E3C4), Color(0xFF4CD1B5)],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TariffCard extends StatelessWidget {
  final String title;
  final String price;
  final String subtitle;
  final List<String> details;
  final bool isActive;

  const _TariffCard({
    required this.title,
    required this.price,
    required this.subtitle,
    required this.details,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.white.withOpacity(0.15)
              : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? const Color(0xFF66E3C4) : Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFF66E3C4) : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isActive ? const Color(0xFF66E3C4) : Colors.white.withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                  child: isActive
                      ? const Center(
                    child: Icon(
                      Icons.check,
                      size: 8,
                      color: Colors.white,
                    ),
                  )
                      : null,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white70,
                fontSize: 12,
              ),
            ),
            if (details.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...details.map((d) => Text(
                d,
                style: TextStyle(
                  color: isActive ? Colors.white70 : Colors.white54,
                  fontSize: 12,
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String text;
  final bool showArrows;
  final double height;
  final double width;
  final double fontSize;
  final List<Color>? gradientColors;

  const _GradientButton({
    required this.text,
    this.showArrows = false,
    this.height = 56,
    this.width = double.infinity,
    this.fontSize = 16,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ?? const [Color(0xFF141530), Color(0xFF141530)];

    return SizedBox(
      width: width,
      height: height,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(colors: colors),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (showArrows)
                Row(
                  children: [
                    Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white),
                    Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white.withOpacity(0.6)),
                    Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white.withOpacity(0.3)),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}