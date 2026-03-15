import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClusterIconPainter {
  final int clusterSize;

  static ui.Image? _scooterImageCache;

  const ClusterIconPainter(this.clusterSize);

  static Future<void> initImage(String assetPath) async {
    if (_scooterImageCache != null) return;
    final data = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    _scooterImageCache = frame.image;
  }

  Future<Uint8List> getClusterIconBytes() async {
    const size = Size(180, 180);
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final mainCenter = Offset(size.width * 0.45, size.height * 0.55);
    final mainRadius = size.width * 0.35;

    final greenPaint = Paint()
      ..color = const Color(0xFF8BFFAA)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(mainCenter, mainRadius, greenPaint);

    if (_scooterImageCache != null) {
      final imageSize = mainRadius * 1.3;
      final rect = Rect.fromCenter(
        center: mainCenter,
        width: imageSize,
        height: imageSize,
      );
      paintImage(
        canvas: canvas,
        image: _scooterImageCache!,
        rect: rect,
        fit: BoxFit.contain,
      );
    }

    if (clusterSize > 1) {
      _drawBadge(canvas, mainCenter, mainRadius);
    }

    final image = await recorder.endRecording().toImage(
      size.width.toInt(),
      size.height.toInt(),
    );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  void _drawBadge(Canvas canvas, Offset mainCenter, double mainRadius) {
    final badgeCenter = Offset(
      mainCenter.dx + mainRadius * 0.7,
      mainCenter.dy - mainRadius * 0.7,
    );
    final badgeRadius = mainRadius * 0.45;

    final badgePaint = Paint()..color = Color(0xFF000032);


    canvas.drawCircle(badgeCenter, badgeRadius, Paint()
      ..color = Colors.black26
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));

    canvas.drawCircle(badgeCenter, badgeRadius, badgePaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: clusterSize > 99 ? '99+' : clusterSize.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: badgeRadius * 1.1,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        badgeCenter.dx - textPainter.width / 2,
        badgeCenter.dy - textPainter.height / 2,
      ),
    );
  }
}
