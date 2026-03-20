import '../../../domain/entities/news.dart';

enum NewsStatus { initial, loading, success, failure }

class NewsState {
  final NewsStatus status;
  final List<NewsEntity> news;
  final String? errorMessage;

  const NewsState({
    required this.status,
    this.news = const [],
    this.errorMessage,
  });

  NewsState copyWith({
    NewsStatus? status,
    List<NewsEntity>? news,
    String? errorMessage,
  }) {
    return NewsState(
      status: status ?? this.status,
      news: news ?? this.news,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isLoading => status == NewsStatus.loading;
  bool get isSuccess => status == NewsStatus.success;
  bool get isFailure => status == NewsStatus.failure;
}