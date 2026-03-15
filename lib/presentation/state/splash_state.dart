import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object> get props => [];
}

// Начальное состояние, когда мы еще не знаем, авторизован ли пользователь
class AuthInitial extends SplashState {}

class AuthInProgress extends SplashState {}

// Пользователь успешно авторизован (токен обновлен)
class AuthAuthenticated extends SplashState {}

// Пользователь не авторизован (нет токена или его не удалось обновить)
class AuthUnauthenticated extends SplashState {}

// Специальное состояние для первого запуска приложения
class AuthFirstLaunch extends SplashState {}
