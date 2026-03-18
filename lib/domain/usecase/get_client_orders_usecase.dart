import 'package:by_happy/core/result.dart';
import 'package:by_happy/domain/entities/scooter_order.dart';

import '../repositories/scooter_repository.dart';


class GetClientOrdersUsecase {
  final ScooterRepository repository;

  GetClientOrdersUsecase(this.repository);

  Future<Result<List<ScooterOrder>>> call(int clientId) {
    return repository.getClientOrders(clientId);
  }
}
