import '../repositories/payment_repository.dart';
import '../../core/result.dart';

class AddPaymentCardUsecase {
  final PaymentRepository repository;

  AddPaymentCardUsecase(this.repository);

  Future<Result<void>> call({
    required String cardNumber,
    required String cardHolder,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
  }) {
    return repository.addPaymentCard(
      cardNumber: cardNumber,
      cardHolder: cardHolder,
      expiryMonth: expiryMonth,
      expiryYear: expiryYear,
      cvv: cvv,
    );
  }
}