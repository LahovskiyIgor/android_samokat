import 'package:by_happy/core/result.dart';
import '../entities/scooter_order.dart';
import '../repositories/scooter_repository.dart';

class UpdateScooterOrderDataUsecase {
  final ScooterRepository repository;

  UpdateScooterOrderDataUsecase(this.repository);

  Future<Result<ScooterOrder>> call({
    required int orderId,
    Map<String, dynamic>? data,
  }) {
    return repository.updateScooterOrderData(
      orderId: orderId,
      data: data,
    );
  }
}
