import 'package:by_happy/core/result.dart';
import 'package:by_happy/domain/entities/scooter_order.dart';
import '../repositories/scooter_repository.dart';

class PayRideUsecase {
  final ScooterRepository repository;

  PayRideUsecase(this.repository);

  Future<Result<ScooterOrder>> call(int orderId) {
    return repository.payRide(orderId);
  }
}
