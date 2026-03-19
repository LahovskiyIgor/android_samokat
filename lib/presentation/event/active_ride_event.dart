sealed class ActiveRideEvent {}

class PauseRide extends ActiveRideEvent {
  final int orderId;
  
  PauseRide(this.orderId);
}

class FinishRide extends ActiveRideEvent {
  final int orderId;
  
  FinishRide(this.orderId);
}
