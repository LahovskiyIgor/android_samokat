import '../../domain/entities/scooter.dart';

enum ScooterStatus { initial, loading, success, failure }

class ScooterDetailState {
  final ScooterStatus status;
  final Scooter? scooter;
  final String? errorMessage;

  const ScooterDetailState({
    this.status = ScooterStatus.initial,
    this.scooter,
    this.errorMessage,
  });

  ScooterDetailState copyWith({
    ScooterStatus? status,
    Scooter? scooter,
    String? errorMessage,
  }) {
    return ScooterDetailState(
      status: status ?? this.status,
      scooter: scooter ?? this.scooter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
