class PaymentCardRequestDto {
  final String cardNumber;
  final int expirationMonth;
  final int expirationYear;
  final String cvv;

  PaymentCardRequestDto({
    required this.cardNumber,
    required this.expirationMonth,
    required this.expirationYear,
    required this.cvv,
  });

  Map<String, dynamic> toJson() {
    return {
      'cardNumber': cardNumber.replaceAll(' ', ''),
      'expirationMonth': expirationMonth,
      'expirationYear': expirationYear,
      'cvv': cvv,
    };
  }
}