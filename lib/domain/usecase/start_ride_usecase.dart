import 'package:by_happy/core/result.dart';
import 'package:by_happy/domain/entities/scooter_order.dart';
import '../repositories/scooter_repository.dart';

class StartRideUsecase {
  final ScooterRepository repository;

  StartRideUsecase(this.repository);

  Future<Result<ScooterOrder>> call(int orderId) {
    return repository.startRide(orderId);
  }
}
