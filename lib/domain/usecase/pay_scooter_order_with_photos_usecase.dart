import 'package:by_happy/core/result.dart';
import '../entities/scooter_order.dart';
import '../repositories/scooter_repository.dart';

class PayScooterOrderWithPhotosUsecase {
  final ScooterRepository repository;

  PayScooterOrderWithPhotosUsecase(this.repository);

  Future<Result<ScooterOrder>> call({
    required int orderId,
    required List<int> filesId,
  }) {
    return repository.payScooterOrderWithPhotos(
      orderId: orderId,
      filesId: filesId,
    );
  }
}
