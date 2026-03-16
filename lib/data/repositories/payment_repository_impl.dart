import 'package:by_happy/domain/entities/payment_card.dart';
import '../../core/failures.dart';
import '../../core/result.dart';
import '../../domain/repositories/payment_repository.dart';
import '../network/api_service.dart';
import '../exceptions/auth_exception.dart';
import '../exceptions/auth_block_exception.dart';
import '../exceptions/unauthorized_exception.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final ApiService apiService;

  PaymentRepositoryImpl(this.apiService);

  @override
  Future<Result<void>> addPaymentCard({
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
  }) async {
    try {
      await apiService.addPaymentCard(
        cardNumber: cardNumber,
        expirationMonth: int.parse(expiryMonth),
        expirationYear: int.parse(expiryYear),
        cvv: cvv,
      );
      return Success(null);
    } on AuthException catch (e) {
      // ✅ Создаём AuthFailure с attemptsLeft
      return Failure(AuthFailure(e.attemptsLeft));
    } on AuthBlockException catch (_) {
      // ✅ Создаём AuthBlockFailure
      return Failure(AuthBlockFailure());
    } on UnauthorizedException catch (_) {
      // ✅ Создаём UnknownFailure (или можно создать UnauthorizedFailure)
      return Failure(UnknownFailure());
    } on FormatException catch (_) {
      return Failure(UnknownFailure());
    } catch (e) {
      // ✅ Любая другая ошибка — UnknownFailure
      return Failure(UnknownFailure());
    }
  }

  @override
  Future<Result<List<PaymentCard>>> getPaymentCards() async {
    try {
      final cards = await apiService.getPaymentCards();
      return Success(cards);
    } on UnauthorizedException catch (_) {
      return Failure(UnknownFailure());
    } on AuthBlockException catch (_) {
      return Failure(AuthBlockFailure());
    } catch (e) {
      return Failure(UnknownFailure());
    }
  }

  @override
  Future<Result<PaymentCard>> setMainPaymentCard(int cardId) async {
    try {
      final card = await apiService.setMainPaymentCard(cardId);
      return Success(card);
    } on UnauthorizedException catch (_) {
      return Failure(UnknownFailure());
    } on AuthBlockException catch (_) {
      return Failure(AuthBlockFailure());
    } catch (e) {
      return Failure(UnknownFailure());
    }
  }
}