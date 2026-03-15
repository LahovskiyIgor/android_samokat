
import '../../domain/entities/scooter.dart';

enum ScooterDetailModalStatus { initial, loading, success, failure }

class ScooterDetailModalState {
  final ScooterDetailModalStatus status;
  final String? address;
  final String? errorMessage;
  final List<Scooter>? scooters;

  ScooterDetailModalState({
    this.status = ScooterDetailModalStatus.initial,
    this.address,
    this.errorMessage,
    this.scooters,
  });

  ScooterDetailModalState copyWith({
    ScooterDetailModalStatus? status,
    double? distance,
    String? address,
    String? errorMessage,
    List<Scooter>? scooters,

  }) => ScooterDetailModalState(
    status: status ?? this.status,
    address: address ?? this.address,
    errorMessage: errorMessage ?? this.errorMessage,
    scooters: scooters ?? this.scooters,
  );
}