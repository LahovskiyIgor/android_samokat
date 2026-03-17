abstract class AddCardEvent {}

class AddCardSubmitted extends AddCardEvent {
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final String cardHolder;

  AddCardSubmitted({
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.cardHolder,
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

class CardHolderChanged extends AddCardEvent {
  final String cardHolder;

  CardHolderChanged(this.cardHolder);
}