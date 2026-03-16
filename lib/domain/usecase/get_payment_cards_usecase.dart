import 'package:by_happy/domain/service/security_service.dart';

import '../entities/payment_card.dart';
import '../repositories/payment_repository.dart';
import '../../core/result.dart';

class GetPaymentCardsUsecase {
  final PaymentRepository repository;
  final SecurityService securityService;

  GetPaymentCardsUsecase(this.repository, this.securityService);

  Future<Result<List<PaymentCard>>> call() async {
    final result = await repository.getPaymentCards();
    
    if (result is Failure) {
      return result;
    }
    
    final cards = (result as Success).data as List<PaymentCard>;
    
    // Для каждой карты получаем полный номер из локального хранилища
    final cardsWithFullNumbers = <PaymentCard>[];
    for (final card in cards) {
      final fullNumber = await securityService.getCardFullNumber(card.id);
      cardsWithFullNumbers.add(card.copyWith(fullCardNumber: fullNumber));
    }
    
    return Success(cardsWithFullNumbers);
  }
}
