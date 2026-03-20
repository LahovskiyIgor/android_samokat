import '../../domain/entities/news.dart';
import '../../domain/repositories/news_repository.dart';
import '../service/news_api_service.dart';
import 'dart:developer' as dev;

class NewsRepositoryImpl implements NewsRepository {
  final NewsApiService _apiService;

  NewsRepositoryImpl(this._apiService);

  @override
  Future<List<NewsEntity>> getNews() async {
    try {
      dev.log('NewsRepository: Загрузка новостей...');

      final response = await _apiService.getNews();
      final List<dynamic> data = response['data'] ?? [];

      final newsList = data.map((json) => NewsEntity.fromJson(json)).toList();

      dev.log('NewsRepository: Загружено ${newsList.length} новостей');

      return newsList;
    } catch (e, stackTrace) {
      dev.log('NewsRepository: Ошибка: $e', stackTrace: stackTrace);
      throw Exception('Не удалось загрузить новости: $e');
    }
  }
}