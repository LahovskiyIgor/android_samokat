import '../repositories/payment_repository.dart';
import '../../core/result.dart';
import '../../domain/service/security_service.dart';

class AddPaymentCardUsecase {
  final PaymentRepository repository;
  final SecurityService securityService;

  AddPaymentCardUsecase(this.repository, this.securityService);

  Future<Result<void>> call({
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
  }) async {
    // Сначала добавляем карту через API
    final result = await repository.addPaymentCard(
      cardNumber: cardNumber,
      expiryMonth: expiryMonth,
      expiryYear: expiryYear,
      cvv: cvv,
    );

    // Если успешно, сохраняем полный номер карты локально
    if (result is Success) {
      // Получаем список карт, чтобы найти ID только что добавленной карты
      final cardsResult = await repository.getPaymentCards();
      if (cardsResult is Success<List>) {
        final cards = cardsResult.data as List;
        if (cards.isNotEmpty) {
          // Находим последнюю добавленную карту (предполагаем, что она последняя в списке)
          final lastCard = cards.last;
          if (lastCard is dynamic && lastCard.id != null) {
            await securityService.saveCardNumber(lastCard.id, cardNumber);
          }
        }
      }
    }

    return result;
  }
}