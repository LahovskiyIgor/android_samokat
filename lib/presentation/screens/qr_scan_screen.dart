import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../components/gradient_button.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final MobileScannerController _controller = MobileScannerController();
  String? _scannedData;
  bool _torchOn = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 📷 Камера — занимает весь экран (реальный фон)
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final String? rawValue = barcode.rawValue;
                if (rawValue != null) {
                  setState(() => _scannedData = rawValue);
                  break;
                }
              }
            },
          ),

          // 🔲 Прозрачная зелёная рамка (прямоуголь без закруглений)
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF6EE7B7), width: 3),
                // borderRadius: BorderRadius.zero, // по умолчанию прямоугольник
              ),
            ),
          ),

          // 📝 Текст сверху — как на скриншоте
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Наведите рамку на QR-код — номер будет распознан автоматически',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // 🟢 Кнопки внизу: GradientButton + фонарик
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: GradientButton(
                        text: 'Ввести номер вручную',
                        onTap: () {
                          // TODO: Перейти на экран ввода
                        },
                        width: double.infinity,
                        height: 56,
                        fontSize: 16,
                        showArrows: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: () async {
                        final newState = !_torchOn;
                        await _controller.toggleTorch();
                        setState(() => _torchOn = newState);
                      },
                      icon: Icon(
                        _torchOn ? Icons.flashlight_on : Icons.flashlight_off,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}