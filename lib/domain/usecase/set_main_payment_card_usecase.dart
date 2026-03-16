import '../repositories/payment_repository.dart';
import '../../core/result.dart';
import '../../domain/entities/payment_card.dart';

class SetMainPaymentCardUsecase {
  final PaymentRepository repository;

  SetMainPaymentCardUsecase(this.repository);

  Future<Result<PaymentCard>> call(int cardId) {
    return repository.setMainPaymentCard(cardId);
  }
}
