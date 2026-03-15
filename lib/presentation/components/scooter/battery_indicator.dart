import 'dart:math';
import 'package:flutter/material.dart';

class BatteryIndicator extends StatelessWidget {
  final double percent;

  const BatteryIndicator({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(320, 320),
            painter: _BatteryRingPainter(percent: percent),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Заряд батареи',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${(percent * 100).toInt()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BatteryRingPainter extends CustomPainter {
  final double percent;

  _BatteryRingPainter({required this.percent});

  // 🔹 Возвращает цвета и stops для текущего диапазона
  (List<Color>, List<double>?) _getGradientForPercent() {
    final p = percent * 100;

    if (p >= 51) {
      return (
      const [
        Color(0xFF86EFAC),
        Color(0xFF67E8F9),
        Color(0xFF86EFAC),
      ],
      const [0.0, 0.5, 1.0],
      );
    } else if (p >= 16) {
      return (
      const [
        Color(0xFFF1FF8B),
        Color(0xFF8BFFAA),
        Color(0xFFF1FF8B),
      ],
      const [0.0, 0.5, 1.0],
      );
    } else {
      return (
      const [
        Color(0xFFFF5757),
        Color(0xFFF1FF8B),
        Color(0xFFFF5757),
      ],
      const [0.0, 0.5, 1.0],
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 20;

    // Фоновое кольцо
    final backgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Деления
    final tickPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 2;
    for (int i = 0; i < 100; i++) {
      final angle = 2 * pi * i / 100 - pi / 2;
      final isMajor = i % 10 == 0;

      final innerRadius = radius - 40;
      final outerRadius = isMajor ? radius - 28 : radius - 32;

      final p1 = Offset(
        center.dx + cos(angle) * innerRadius,
        center.dy + sin(angle) * innerRadius,
      );
      final p2 = Offset(
        center.dx + cos(angle) * outerRadius,
        center.dy + sin(angle) * outerRadius,
      );

      canvas.drawLine(p1, p2, tickPaint);
    }

    // Получаем градиент по проценту
    final (colors, stops) = _getGradientForPercent();

    // Glow дуга
    final glowPaint = Paint()
      ..shader = SweepGradient(
        colors: colors,
        stops: stops,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 85)
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * percent,
      false,
      glowPaint,
    );

    // Основная дуга
    final progressPaint = Paint()
      ..shader = SweepGradient(
        colors: colors,
        stops: stops,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * percent,
      false,
      progressPaint,
    );

    // Внутренний круг
    final innerCircle = Paint()
      ..color = const Color(0xFF16233F)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 60, innerCircle);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}