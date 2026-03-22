sealed class PaymentConfirmEvent {}

class PayRide extends PaymentConfirmEvent {
  final int orderId;
  final List<int> photoIds;

  PayRide({
    required this.orderId,
    required this.photoIds,
  });
}
