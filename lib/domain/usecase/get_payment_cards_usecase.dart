import '../repositories/payment_repository.dart';
import '../../core/result.dart';
import '../../domain/entities/payment_card.dart';

class GetPaymentCardsUsecase {
  final PaymentRepository repository;

  GetPaymentCardsUsecase(this.repository);

  Future<Result<List<PaymentCard>>> call() {
    return repository.getPaymentCards();
  }
}
