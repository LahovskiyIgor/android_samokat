sealed class ReservedRideEvent {}

class StartRide extends ReservedRideEvent {
  final int orderId;
  
  StartRide(this.orderId);
}

class CancelRide extends ReservedRideEvent {
  final int orderId;
  
  CancelRide(this.orderId);
}
