import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as dev;
import '../../../domain/repositories/news_repository.dart';
import '../event/news_event.dart';
import '../state/news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository _newsRepository;

  NewsBloc(this._newsRepository) : super(const NewsState(status: NewsStatus.initial)) {
    on<NewsFetchRequested>(_onFetchRequested);
  }

  Future<void> _onFetchRequested(
      NewsFetchRequested event,
      Emitter<NewsState> emit,
      ) async {
    dev.log('NewsBloc: Получено событие NewsFetchRequested');

    emit(state.copyWith(status: NewsStatus.loading));

    try {
      final news = await _newsRepository.getNews();

      dev.log('NewsBloc: Успешно загружено ${news.length} новостей');

      emit(state.copyWith(
        status: NewsStatus.success,
        news: news,
      ));
    } catch (e, stackTrace) {
      dev.log('NewsBloc: Ошибка: $e', stackTrace: stackTrace);

      emit(state.copyWith(
        status: NewsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}