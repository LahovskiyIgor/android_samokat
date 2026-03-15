import '../../domain/entities/scooter.dart';

sealed class ScooterDetailModalEvent {}

class ScooterDetailModalStarted extends ScooterDetailModalEvent {
  final List<Scooter> scooters;
  final double userLatitude;
  final double userLongitude;

  ScooterDetailModalStarted(this.scooters, this.userLatitude, this.userLongitude);
}


