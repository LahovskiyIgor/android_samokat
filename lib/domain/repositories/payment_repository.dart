import 'package:by_happy/domain/entities/payment_card.dart';
import '../../core/result.dart';

abstract class PaymentRepository {
  Future<Result<void>> addPaymentCard({
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
  });

  Future<Result<List<PaymentCard>>> getPaymentCards();

  Future<Result<PaymentCard>> setMainPaymentCard(int cardId);
}