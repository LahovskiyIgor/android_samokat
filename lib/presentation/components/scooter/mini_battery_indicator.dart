import 'dart:math';
import 'package:flutter/material.dart';

class MiniBatteryIndicator extends StatelessWidget {
  final int percent;

  const MiniBatteryIndicator({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: CustomPaint(
        painter: _MiniBatteryRingPainter(percent: percent),
      ),
    );
  }
}

class _MiniBatteryRingPainter extends CustomPainter {
  final int percent;

  _MiniBatteryRingPainter({required this.percent});

  (List<Color>, List<double>?) _getGradientForPercent() {
    final p = percent;

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
    final radius = size.width / 2 - 4; // поменьше

    // Фоновое кольцо
    final backgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Получаем цвета
    final (colors, stops) = _getGradientForPercent();

    // Основная дуга
    final progressPaint = Paint()
      ..shader = SweepGradient(
        colors: colors,
        stops: stops,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * (percent / 100),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
