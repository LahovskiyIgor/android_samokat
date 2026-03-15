import 'package:flutter/material.dart';
import '../components/gradient_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'image': 'assets/onboard_1.jpg',
      'title': 'Найдите самокат на карте и выберите нужный',
    },
    {
      'image': 'assets/onboard_2.jpg',
      'title': 'Отсканируйте QR-код или введите номер который указан под козлом',
    },
    {
      'image': 'assets/onboard_3.png',
      'title': 'Дождитесь звукового сигнала. При наличии замка отстегните его',
    },
    {
      'image': 'assets/onboard_4.jpg',
      'title': 'Выберите тариф и начните поездку',
    },
    {
      'image': 'assets/onboard_5.jpg',
      'title': 'Управляйте скоростью с помощью курка тормоза',
    },
    {
      'image': 'assets/onboard_6.jpg',
      'title': 'Для торможения используйте курок тормоза',
    },
    {
      'image': 'assets/onboard_7.png',
      'title': 'Для завершения аренды припаркуйте самокат в разрешённом месте',
    },
  ];

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // TODO: переход дальше (авторизация / главная)
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Фон — PageView
          PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.asset(
                _slides[index]['image']!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),

          /// Градиент сверху для читаемости
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.35),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.7],
              ),
            ),
          ),

          /// Контент
          SafeArea(
            child: Column(
              children: [
                const Expanded(child: SizedBox()),

                /// Текст
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    _slides[_currentPage]['title']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 32),

                /// Кнопка
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GradientButton(
                    text: _currentPage == _slides.length - 1
                        ? 'Начать'
                        : 'Далее',
                    onTap: _nextPage,
                    width: double.infinity,
                    height: 56,
                    fontSize: 18,
                    showArrows: true,
                  ),
                ),

                const SizedBox(height: 24),

                /// Индикатор
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_slides.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: index == _currentPage ? 10 : 8,
                      height: index == _currentPage ? 10 : 8,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: index == _currentPage
                            ? Colors.greenAccent
                            : Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
