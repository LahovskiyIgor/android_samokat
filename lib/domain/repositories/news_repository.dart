import '../entities/news.dart';

abstract class NewsRepository {
  Future<List<NewsEntity>> getNews();
}