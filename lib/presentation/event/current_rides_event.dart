sealed class CurrentRidesEvent {}

class LoadClientOrders extends CurrentRidesEvent {
  final int clientId;
  
  LoadClientOrders(this.clientId);
}
