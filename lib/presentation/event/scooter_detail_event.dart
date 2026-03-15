sealed class ScooterDetailEvent {}

class LoadScooterDetails extends ScooterDetailEvent {
  final int scooterId;
  LoadScooterDetails(this.scooterId);
}
