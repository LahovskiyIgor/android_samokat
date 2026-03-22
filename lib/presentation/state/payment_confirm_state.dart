enum PaymentConfirmStatus { initial, loading, success, failure }

class PaymentConfirmState {
  final PaymentConfirmStatus status;
  final String? errorMessage;
  final bool paymentCompleted;

  const PaymentConfirmState({
    this.status = PaymentConfirmStatus.initial,
    this.errorMessage,
    this.paymentCompleted = false,
  });

  PaymentConfirmState copyWith({
    PaymentConfirmStatus? status,
    String? errorMessage,
    bool? paymentCompleted,
  }) {
    return PaymentConfirmState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      paymentCompleted: paymentCompleted ?? this.paymentCompleted,
    );
  }
}
