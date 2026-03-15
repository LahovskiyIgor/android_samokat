import 'package:equatable/equatable.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object> get props => [];
}

// Событие, которое будет отправляться со SplashScreen
class AuthCheckRequested extends SplashEvent {}

class AuthStarted extends SplashEvent {}
