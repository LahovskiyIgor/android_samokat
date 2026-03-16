import '../../core/failures.dart';
import '../../core/result.dart';
import '../../domain/entities/payment_card.dart';
import '../../domain/repositories/payment_repository.dart';
import '../network/api_service.dart';
import '../exceptions/auth_exception.dart';
import '../exceptions/auth_block_exception.dart';
import '../exceptions/unauthorized_exception.dart';
import '../service/security_service_impl.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final ApiService apiService;
  final SecurityServiceImpl securityService;

  PaymentRepositoryImpl(this.apiService, this.securityService);

  @override
  Future<Result<List<PaymentCard>>> getPaymentCards() async {
    try {
      final cards = await apiService.getPaymentCards();
      return Success(cards);
    } on AuthException catch (e) {
      return Failure(AuthFailure(e.attemptsLeft));
    } on AuthBlockException catch (_) {
      return Failure(AuthBlockFailure());
    } on UnauthorizedException catch (_) {
      return Failure(UnknownFailure());
    } catch (e) {
      return Failure(UnknownFailure());
    }
  }

  @override
  Future<Result<void>> addPaymentCard({
    required String cardNumber,
    required String cardHolder,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
  }) async {
    try {
      final cardId = await apiService.addPaymentCard(
        cardNumber: cardNumber,
        cardHolder: cardHolder,
        expirationMonth: int.parse(expiryMonth),
        expirationYear: int.parse(expiryYear),
        cvv: cvv,
      );
      
      // Сохраняем полный номер карты локально
      await securityService.saveCardFullNumber(cardId, cardNumber);
      
      return Success(null);
    } on AuthException catch (e) {
      return Failure(AuthFailure(e.attemptsLeft));
    } on AuthBlockException catch (_) {
      return Failure(AuthBlockFailure());
    } on UnauthorizedException catch (_) {
      return Failure(UnknownFailure());
    } on FormatException catch (_) {
      return Failure(UnknownFailure());
    } catch (e) {
      return Failure(UnknownFailure());
    }
  }

  @override
  Future<Result<void>> setMainPaymentCard(int cardId) async {
    try {
      await apiService.setMainPaymentCard(cardId);
      return Success(null);
    } on AuthException catch (e) {
      return Failure(AuthFailure(e.attemptsLeft));
    } on AuthBlockException catch (_) {
      return Failure(AuthBlockFailure());
    } on UnauthorizedException catch (_) {
      return Failure(UnknownFailure());
    } catch (e) {
      return Failure(UnknownFailure());
    }
  }

  @override
  Future<Result<void>> removePaymentCard(int cardId) async {
    try {
      await apiService.removePaymentCard(cardId);
      await securityService.removeCardFullNumber(cardId);
      return Success(null);
    } on AuthException catch (e) {
      return Failure(AuthFailure(e.attemptsLeft));
    } on AuthBlockException catch (_) {
      return Failure(AuthBlockFailure());
    } on UnauthorizedException catch (_) {
      return Failure(UnknownFailure());
    } catch (e) {
      return Failure(UnknownFailure());
    }
  }
}