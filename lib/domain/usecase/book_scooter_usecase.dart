import 'package:by_happy/core/result.dart';
import 'package:by_happy/domain/entities/scooter_order.dart';
import '../repositories/scooter_repository.dart';

class BookScooterUsecase {
  final ScooterRepository repository;

  BookScooterUsecase(this.repository);

  Future<Result<ScooterOrder>> call({
    required int scooterId,
    required int planId,
    int? subscriptionId,
    int? cardId,
    required bool isBalance,
    required bool isInsurance,
  }) {
    return repository.bookScooter(
      scooterId: scooterId,
      planId: planId,
      subscriptionId: subscriptionId,
      cardId: cardId,
      isBalance: isBalance,
      isInsurance: isInsurance,
    );
  }
}
