import '../../domain/entities/scooter.dart';
import '../../domain/entities/zone.dart';

enum ScooterStatus { initial, loading, success, failure }

class ScooterState {
  final List<Scooter> scooters;
  final List<Zone> zones;
  final List<double> area;
  final ScooterStatus status;
  final bool isGeomarksShowed;
  final String? address;
  final String? errorMessage;

  ScooterState({
    this.scooters = const [],
    this.zones = const [],
    this.area = const [],
    this.status = ScooterStatus.initial,
    required this.isGeomarksShowed,
    this.address,
    this.errorMessage,
  });

  ScooterState copyWith({
    List<Scooter>? scooters,
    List<Zone>? zones,
    List<double>? area,
    ScooterStatus? status,
    bool? isGeomarksShowed,
    String? address,
    String? errorMessage,
  }) {
    return ScooterState(
      scooters: scooters ?? this.scooters,
      zones: zones ?? this.zones,
      area: area ?? this.area,
      status: status ?? this.status,
      address: address ?? this.address,
      isGeomarksShowed: isGeomarksShowed?? this.isGeomarksShowed,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
