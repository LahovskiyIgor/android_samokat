import 'dart:developer' as dev;
import '../network/api_service.dart';

class NewsApiService {
  final ApiService _apiService;

  NewsApiService(this._apiService);

  Future<Map<String, dynamic>> getNews() async {
    try {
      dev.log('NewsApiService: Запрос GET /news');

      final response = await _apiService.getNews();

      dev.log('NewsApiService: Успешно получено ${response['data']?.length ?? 0} новостей');
      return response;
    } catch (e, stackTrace) {
      dev.log('NewsApiService: Ошибка: $e', stackTrace: stackTrace);
      throw Exception('Не удалось загрузить новости: $e');
    }
  }
}