import 'dart:async';

import 'package:by_happy/domain/usecase/refresh_token_usecase.dart';
import 'package:by_happy/presentation/event/spalsh_event.dart';
import 'package:by_happy/presentation/state/splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final RefreshTokenUseCase _refreshTokenUseCase;

  SplashBloc(this._refreshTokenUseCase):
        super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthStarted>(_onAuthStarted);
  }

  Future<void> _onAuthCheckRequested(
      AuthCheckRequested event,
      Emitter<SplashState> emit,
      ) async {
    print('AuthBloc: Получено событие AuthCheckRequested.');
    final prefs = await SharedPreferences.getInstance();
    final bool isFirstLaunch = prefs.getBool('is_first_launch') ?? true;

    if (isFirstLaunch) {
      await prefs.setBool('is_first_launch', false);
      emit(AuthFirstLaunch());
      return;
    }

    // 2. Если не первый запуск, пытаемся обновить токен
    try {
      print('AuthBloc: Пытаюсь обновить токен...');
      // Здесь вызывается ваш метод refreshToken()
      await _refreshTokenUseCase.execute();
      print('AuthBloc: Токен успешно обновлен. Отправляю AuthAuthenticated.');
      // Если метод выполнился без исключений, значит токен успешно обновлен
      emit(AuthAuthenticated());
    } catch (e) {
      print('AuthBloc: Ошибка при обновлении токена: $e');
      // Если refreshToken() бросил исключение, значит что-то пошло не так
      emit(AuthUnauthenticated());
    }
  }

  FutureOr<void> _onAuthStarted(AuthStarted event, Emitter<SplashState> emit) {
    emit(AuthInProgress());
  }
}
