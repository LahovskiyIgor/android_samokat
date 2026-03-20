import '../../domain/entities/scooter_order.dart';

enum ActiveRideStatus { initial, loading, success, failure }

class ActiveRideState {
  final ActiveRideStatus status;
  final ScooterOrder? order;
  final String? errorMessage;
  final Duration elapsedTime;
  final double speed;
  final double distance;
  final double cost;
  final bool isPaused;

  const ActiveRideState({
    this.status = ActiveRideStatus.initial,
    this.order,
    this.errorMessage,
    this.elapsedTime = Duration.zero,
    this.speed = 0.0,
    this.distance = 0.0,
    this.cost = 0.0,
    this.isPaused = false,
  });

  ActiveRideState copyWith({
    ActiveRideStatus? status,
    ScooterOrder? order,
    String? errorMessage,
    Duration? elapsedTime,
    double? speed,
    double? distance,
    double? cost,
    bool? isPaused,
  }) {
    return ActiveRideState(
      status: status ?? this.status,
      order: order ?? this.order,
      errorMessage: errorMessage ?? this.errorMessage,
      elapsedTime: elapsedTime ?? this.elapsedTime,
      speed: speed ?? this.speed,
      distance: distance ?? this.distance,
      cost: cost ?? this.cost,
      isPaused: isPaused ?? this.isPaused,
    );
  }

  @override
  String toString() {
    return 'ActiveRideState{status: $status, cost: $cost, isPaused: $isPaused}';
  }
}
