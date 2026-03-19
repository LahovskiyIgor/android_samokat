import 'package:by_happy/core/result.dart';
import '../entities/scooter_order.dart';
import '../repositories/scooter_repository.dart';

class GetScooterOrderByIdUsecase {
  final ScooterRepository repository;

  GetScooterOrderByIdUsecase(this.repository);

  Future<Result<ScooterOrder>> call(int id) {
    return repository.getScooterOrderById(id);
  }
}
