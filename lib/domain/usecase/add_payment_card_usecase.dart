import '../repositories/payment_repository.dart';
import '../../core/result.dart';
import '../entities/payment_card.dart';

class AddPaymentCardUsecase {
  final PaymentRepository repository;

  AddPaymentCardUsecase(this.repository);

  Future<Result<void>> call({
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
    required String cardHolder,
  }) {
    return repository.addPaymentCard(
      cardNumber: cardNumber,
      expiryMonth: expiryMonth,
      expiryYear: expiryYear,
      cvv: cvv,
      cardHolder: cardHolder,
    );
  }
}

class GetPaymentCardsUsecase {
  final PaymentRepository repository;

  GetPaymentCardsUsecase(this.repository);

  Future<Result<List<PaymentCard>>> call() {
    return repository.getPaymentCards();
  }
}

class SetMainPaymentCardUsecase {
  final PaymentRepository repository;

  SetMainPaymentCardUsecase(this.repository);

  Future<Result<void>> call(int cardId) {
    return repository.setMainPaymentCard(cardId);
  }
}