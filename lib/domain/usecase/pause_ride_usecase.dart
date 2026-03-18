import 'package:by_happy/core/result.dart';
import 'package:by_happy/domain/entities/scooter_order.dart';
import '../repositories/scooter_repository.dart';

class PauseRideUsecase {
  final ScooterRepository repository;

  PauseRideUsecase(this.repository);

  Future<Result<ScooterOrder>> call(int orderId) {
    return repository.pauseRide(orderId);
  }
}
