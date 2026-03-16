import '../../core/result.dart';
import '../entities/payment_card.dart';

abstract class PaymentRepository {
  Future<Result<List<PaymentCard>>> getPaymentCards();
  Future<Result<void>> addPaymentCard({
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
    required String cardHolder,
  });
  Future<Result<void>> setMainPaymentCard(int cardId);
}