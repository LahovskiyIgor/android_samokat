import '../../domain/entities/scooter_order.dart';

enum CurrentRidesStatus { initial, loading, success, failure }

class CurrentRidesState {
  final CurrentRidesStatus status;
  final List<ScooterOrder> orders;
  final String? errorMessage;

  const CurrentRidesState({
    this.status = CurrentRidesStatus.initial,
    this.orders = const [],
    this.errorMessage,
  });

  CurrentRidesState copyWith({
    CurrentRidesStatus? status,
    List<ScooterOrder>? orders,
    String? errorMessage,
  }) {
    return CurrentRidesState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
