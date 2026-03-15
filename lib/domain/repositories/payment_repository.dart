import '../../core/result.dart';

abstract class PaymentRepository {
  Future<Result<void>> addPaymentCard({
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
  });
}