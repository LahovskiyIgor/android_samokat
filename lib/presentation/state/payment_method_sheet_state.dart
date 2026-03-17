import '../../domain/entities/payment_card.dart';

enum PaymentMethodSheetStatus { initial, loading, success, failure }

class PaymentMethodSheetState {
  final PaymentMethodSheetStatus status;
  final List<PaymentCard> cards;
  final double balance;
  final String? errorMessage;

  PaymentMethodSheetState({
    this.status = PaymentMethodSheetStatus.initial,
    this.cards = const [],
    this.balance = 0.0,
    this.errorMessage,
  });

  PaymentMethodSheetState copyWith({
    PaymentMethodSheetStatus? status,
    List<PaymentCard>? cards,
    double? balance,
    String? errorMessage,
  }) =>
      PaymentMethodSheetState(
        status: status ?? this.status,
        cards: cards ?? this.cards,
        balance: balance ?? this.balance,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
