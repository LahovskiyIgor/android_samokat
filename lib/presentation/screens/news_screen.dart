import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as dev;
import '../../core/app_colors.dart';
import '../../di/service_locator.dart';
import '../components/custom_app_bar.dart';
import '../event/news_event.dart';
import '../state/news_state.dart';
import '../viewmodel/news_bloc.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    dev.log('🔍 NewsScreen: Создание экрана новостей');

    return BlocProvider(
      create: (context) {
        dev.log('🔍 NewsScreen: Создание NewsBloc');
        return getIt<NewsBloc>()..add(const NewsFetchRequested());
      },
      child: const NewsView(),
    );
  }
}

class NewsView extends StatelessWidget {
  const NewsView({super.key});

  @override
  Widget build(BuildContext context) {
    dev.log('🔍 NewsView: Построение UI');

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.phoneScreenBg),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomAppBar(title: 'Новости'),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: BlocBuilder<NewsBloc, NewsState>(
                  builder: (context, state) {
                    dev.log('🔍 NewsView: Состояние ${state.status}, новостей: ${state.news.length}');

                    if (state.status == NewsStatus.initial || state.status == NewsStatus.loading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }

                    if (state.status == NewsStatus.failure) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Ошибка загрузки новостей',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                state.errorMessage ?? '',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                dev.log('🔍 NewsView: Повторная загрузка');
                                context.read<NewsBloc>().add(const NewsFetchRequested());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.smsDigit,
                              ),
                              child: const Text('Повторить'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state.news.isEmpty) {
                      return const _EmptyState();
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: state.news.length,
                      itemBuilder: (context, index) {
                        return _NewsCard(news: state.news[index]);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/news_empty.png',
          width: 280,
          height: 280,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.newspaper_outlined,
              size: 120,
              color: Colors.white38,
            );
          },
        ),
        const SizedBox(height: 32),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Следите за нашими последними новостями и акциями! Сейчас их нет, но скоро они появятся.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _NewsCard extends StatelessWidget {
  final dynamic news;

  const _NewsCard({required this.news});

  @override
  Widget build(BuildContext context) {
    final date = _formatDate(news.publishedAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141530),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: const TextStyle(
              color: AppColors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            news.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            news.previewText,
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
              onPressed: () {
                // TODO: Открыть полную новость
                dev.log('📰 Открыть новость: ${news.id}');
              },
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
                  const Text(
                    'Подробнее',
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Сегодня, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Вчера, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
  }
}