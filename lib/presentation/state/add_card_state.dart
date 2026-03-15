enum AddCardStatus { initial, loading, success, failure }

class AddCardState {
  final AddCardStatus status;
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final String errorMessage;

  const AddCardState({
    this.status = AddCardStatus.initial,
    this.cardNumber = '',
    this.expiryDate = '',
    this.cvv = '',
    this.errorMessage = '',
  });

  AddCardState copyWith({
    AddCardStatus? status,
    String? cardNumber,
    String? expiryDate,
    String? cvv,
    String? errorMessage,
  }) {
    return AddCardState(
      status: status ?? this.status,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isFormValid {
    final cleanCardNumber = cardNumber.replaceAll(' ', '');
    return cleanCardNumber.length == 16 &&
        expiryDate.length == 5 &&
        cvv.length == 3;
  }
}