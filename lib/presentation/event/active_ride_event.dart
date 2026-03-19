sealed class ActiveRideEvent {}

class LoadScooterOrder extends ActiveRideEvent {
  final int orderId;
  
  LoadScooterOrder(this.orderId);
}

class PauseRide extends ActiveRideEvent {
  final int orderId;
  
  PauseRide(this.orderId);
}

class ResumeRide extends ActiveRideEvent {
  final int orderId;
  
  ResumeRide(this.orderId);
}

class FinishRide extends ActiveRideEvent {
  final int orderId;
  
  FinishRide(this.orderId);
}
