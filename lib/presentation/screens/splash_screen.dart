
import 'package:by_happy/presentation/event/spalsh_event.dart';
import 'package:by_happy/presentation/viewmodel/splash_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Подключи сюда свои реальные экраны:
import 'phone_screen.dart';
import 'pin_login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _revealAnimation;

  static const double logoSize = 300;

  @override
  void initState() {
    super.initState();

    // контроллер анимации
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // анимация движения "затемняющего" прямоугольника
    _revealAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // запускаем анимацию
    _controller.forward().then((_) async {
      // небольшая пауза после анимации
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) {
        return;
      }
      context.read<SplashBloc>().add(AuthCheckRequested());
    });

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3A3A3A),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final double offset = _revealAnimation.value * (logoSize * 1.2);

            return Stack(
              alignment: Alignment.center,
              children: [
                // Цветной логотип (на заднем плане)
                Image.asset(
                  'assets/logo_color.png',
                  width: logoSize,
                  height: logoSize,
                  fit: BoxFit.contain,
                ),

                // Прямоугольник, который "уезжает" вправо, открывая логотип
                ClipRect(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: Container(
                        width: logoSize,
                        height: logoSize,
                        color: const Color(0xFF3A3A3A),
                        transform: Matrix4.translationValues(offset, 0, 0),
                      ),
                    ),
                  ),
                ),

                // Обводка логотипа (поверх)
                Image.asset(
                  'assets/logo_outline.png',
                  width: logoSize * 1.01,
                  height: logoSize * 1.01,
                  fit: BoxFit.contain,
                ),
              ],
            );
          },
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Text(
          'Версия приложения 1.0',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ),
    );
  }

}
