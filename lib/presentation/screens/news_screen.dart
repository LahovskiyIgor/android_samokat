import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../components/custom_app_bar.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NewsItem> news = [
      // NewsItem(
      //   date: 'Сегодня, 11:31',
      //   title: 'Бесплатный старт',
      //   body: 'Ваши друзья получат бесплатный старт на первую поездку. После того, как они её совершат, вы получите бонусные баллы на счёт!',
      //   buttonText: 'Подробнее',
      // ),
      // NewsItem(
      //   date: 'Вчера, 14:45',
      //   title: 'Новый тариф «Эконом»',
      //   body: 'Теперь вы можете выбрать более выгодный тариф для коротких поездок — от 10 руб/мин.',
      //   buttonText: 'Подробнее',
      // ),
      // NewsItem(
      //   date: '15 мая, 09:20',
      //   title: 'Обновление приложения',
      //   body: 'Добавлены уведомления о доступности самокатов в зоне вашего местоположения.',
      //   buttonText: 'Подробнее',
      // ),
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.phoneScreenBg),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const CustomAppBar(title: 'Новости'),
              const SizedBox(height: 32),

              if (news.isEmpty)
                _EmptyState()
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: news.length,
                    itemBuilder: (context, index) {
                      return _NewsCard(news[index]);
                    },
                  ),
                ),

              const SizedBox(height: 20),
              Image.asset(
                'assets/wave.png',
                width: double.infinity,
                fit: BoxFit.fitWidth,
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

class NewsItem {
  final String date;
  final String title;
  final String body;
  final String buttonText;

  NewsItem({
    required this.date,
    required this.title,
    required this.body,
    required this.buttonText,
  });
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/news_empty.png',
            width: 280,
            height: 280,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 32),
          const Text(
            'Следите за нашими последними новостями и акциями! Сейчас их нет, но скоро они появятся.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final NewsItem item;

  const _NewsCard(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF141530),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.date,
            style: const TextStyle(
              color: AppColors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.body,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                side: BorderSide(color: AppColors.smsDigit.withOpacity(0.3)),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.buttonText,
                    style: TextStyle(color: AppColors.smsDigit),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: 12,
                    color: AppColors.smsDigit,
                  ),
                  Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: 12,
                    color: AppColors.smsDigit.withOpacity(0.6),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: 12,
                    color: AppColors.smsDigit.withOpacity(0.3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}