import 'package:by_happy/data/models/user_response_dto.dart';
import 'package:by_happy/domain/entities/payment_card.dart';
import 'package:by_happy/domain/service/security_service.dart';

import '../../core/failures.dart';
import '../../core/result.dart';
import '../../domain/repositories/payment_repository.dart';
import '../network/api_service.dart';
import '../exceptions/auth_exception.dart';
import '../exceptions/auth_block_exception.dart';
import '../exceptions/unauthorized_exception.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final ApiService apiService;
  final SecurityService securityService;

  PaymentRepositoryImpl(this.apiService, this.securityService);

  @override
  Future<Result<List<PaymentCard>>> getPaymentCards() async {
    try {
      final userResponse = await apiService.getUserProfile();
      if (userResponse == null) {
        return Failure(UnknownFailure());
      }

      final cards = <PaymentCard>[];
      for (final cardDto in userResponse.clientCards) {
        final fullCardNumber = await securityService.getCardNumber(cardDto.id);
        
        cards.add(PaymentCard(
          id: cardDto.id,
          clientId: cardDto.clientId,
          expirationMonth: cardDto.expirationMonth,
          expirationYear: cardDto.expirationYear,
          cardHolder: cardDto.cardHolder,
          cardLastNumber: cardDto.cardLastNumber,
          isMain: cardDto.isMain,
          fullCardNumber: fullCardNumber,
        ));
      }

      return Success(cards);
    } on UnauthorizedException catch (_) {
      return Failure(UnknownFailure());
    } on AuthException catch (e) {
      return Failure(AuthFailure(e.attemptsLeft));
    } on AuthBlockException catch (_) {
      return Failure(AuthBlockFailure());
    } catch (e) {
      return Failure(UnknownFailure());
    }
  }

  @override
  Future<Result<void>> addPaymentCard({
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
    required String cardHolder,
  }) async {
    try {
      final cardId = await apiService.addPaymentCard(
        cardNumber: cardNumber,
        expirationMonth: int.parse(expiryMonth),
        expirationYear: int.parse(expiryYear),
        cvv: cvv,
        cardHolder: cardHolder,
      );
      
      // Сохраняем полный номер карты локально
      if (cardId != null) {
        await securityService.saveCardNumber(cardId, cardNumber);
      }
      
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
    } on UnauthorizedException catch (_) {
      return Failure(UnknownFailure());
    } on AuthException catch (e) {
      return Failure(AuthFailure(e.attemptsLeft));
    } on AuthBlockException catch (_) {
      return Failure(AuthBlockFailure());
    } catch (e) {
      return Failure(UnknownFailure());
    }
  }
}