import '../repositories/payment_repository.dart';
import '../../core/result.dart';

class SetMainPaymentCardUsecase {
  final PaymentRepository repository;

  SetMainPaymentCardUsecase(this.repository);

  Future<Result<void>> call(int cardId) {
    return repository.setMainPaymentCard(cardId);
  }
}
