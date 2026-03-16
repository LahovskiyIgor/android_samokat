class PaymentCard {
  final int id;
  final int clientId;
  final int expirationMonth;
  final int expirationYear;
  final String cardHolder;
  final String cardLastNumber;
  final bool isMain;
  final String? fullCardNumber; // Полный номер карты (хранится локально)

  PaymentCard({
    required this.id,
    required this.clientId,
    required this.expirationMonth,
    required this.expirationYear,
    required this.cardHolder,
    required this.cardLastNumber,
    required this.isMain,
    this.fullCardNumber,
  });

  PaymentCard copyWith({
    int? id,
    int? clientId,
    int? expirationMonth,
    int? expirationYear,
    String? cardHolder,
    String? cardLastNumber,
    bool? isMain,
    String? fullCardNumber,
  }) {
    return PaymentCard(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      expirationMonth: expirationMonth ?? this.expirationMonth,
      expirationYear: expirationYear ?? this.expirationYear,
      cardHolder: cardHolder ?? this.cardHolder,
      cardLastNumber: cardLastNumber ?? this.cardLastNumber,
      isMain: isMain ?? this.isMain,
      fullCardNumber: fullCardNumber ?? this.fullCardNumber,
    );
  }
}