abstract class ScooterEvent {}

class FetchScooters extends ScooterEvent {
  final List<double> area;
  FetchScooters(this.area);
}

class UpdateMap extends ScooterEvent {}


