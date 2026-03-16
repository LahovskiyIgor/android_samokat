import '../../domain/entities/payment_card.dart';

class PaymentCardResponseDto {
  final int id;
  final int clientId;
  final int expirationMonth;
  final int expirationYear;
  final String cardHolder;
  final String cardLastNumber;
  final bool isMain;

  PaymentCardResponseDto({
    required this.id,
    required this.clientId,
    required this.expirationMonth,
    required this.expirationYear,
    required this.cardHolder,
    required this.cardLastNumber,
    required this.isMain,
  });

  factory PaymentCardResponseDto.fromJson(Map<String, dynamic> json) {
    return PaymentCardResponseDto(
      id: json['id'] as int,
      clientId: json['clientId'] as int,
      expirationMonth: json['expirationMonth'] as int,
      expirationYear: json['expirationYear'] as int,
      cardHolder: json['cardHolder'] as String,
      cardLastNumber: json['cardLastNumber'] as String,
      isMain: json['isMain'] as bool,
    );
  }

  PaymentCard toEntity({String? fullCardNumber}) {
    return PaymentCard(
      id: id,
      clientId: clientId,
      expirationMonth: expirationMonth,
      expirationYear: expirationYear,
      cardHolder: cardHolder,
      cardLastNumber: cardLastNumber,
      isMain: isMain,
      fullCardNumber: fullCardNumber,
    );
  }
}
