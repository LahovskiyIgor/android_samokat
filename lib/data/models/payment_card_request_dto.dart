class PaymentCardRequestDto {
  final String cardNumber;
  final String cardHolder;
  final int expirationMonth;
  final int expirationYear;
  final String cvv;

  PaymentCardRequestDto({
    required this.cardNumber,
    required this.cardHolder,
    required this.expirationMonth,
    required this.expirationYear,
    required this.cvv,
  });

  Map<String, dynamic> toJson() {
    return {
      'cardNumber': cardNumber.replaceAll(' ', ''),
      'cardHolder': cardHolder,
      'expirationMonth': expirationMonth,
      'expirationYear': expirationYear,
      'cvv': cvv,
    };
  }
}