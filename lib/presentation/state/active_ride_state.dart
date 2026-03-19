import '../../domain/entities/scooter_order.dart';

enum ActiveRideStatus { initial, loading, success, failure }

class ActiveRideState {
  final ActiveRideStatus status;
  final ScooterOrder? scooterOrder;
  final String? errorMessage;
  final bool isPaused;
  final Duration elapsedTime;
  final double speed;
  final double distance;
  final double cost;

  const ActiveRideState({
    this.status = ActiveRideStatus.initial,
    this.scooterOrder,
    this.errorMessage,
    this.isPaused = false,
    this.elapsedTime = Duration.zero,
    this.speed = 0.0,
    this.distance = 0.0,
    this.cost = 0.0,
  });

  ActiveRideState copyWith({
    ActiveRideStatus? status,
    ScooterOrder? scooterOrder,
    String? errorMessage,
    bool? isPaused,
    Duration? elapsedTime,
    double? speed,
    double? distance,
    double? cost,
  }) {
    return ActiveRideState(
      status: status ?? this.status,
      scooterOrder: scooterOrder ?? this.scooterOrder,
      errorMessage: errorMessage ?? this.errorMessage,
      isPaused: isPaused ?? this.isPaused,
      elapsedTime: elapsedTime ?? this.elapsedTime,
      speed: speed ?? this.speed,
      distance: distance ?? this.distance,
      cost: cost ?? this.cost,
    );
  }
}
