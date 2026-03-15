abstract class AddCardEvent {}

class AddCardSubmitted extends AddCardEvent {
  final String cardNumber;
  final String expiryDate;
  final String cvv;

  AddCardSubmitted({
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
  });
}

class CardNumberChanged extends AddCardEvent {
  final String cardNumber;

  CardNumberChanged(this.cardNumber);
}

class ExpiryDateChanged extends AddCardEvent {
  final String expiryDate;

  ExpiryDateChanged(this.expiryDate);
}

class CvvChanged extends AddCardEvent {
  final String cvv;

  CvvChanged(this.cvv);
}