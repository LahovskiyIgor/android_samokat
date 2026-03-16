import 'package:by_happy/core/result.dart';
import 'package:by_happy/domain/entities/tariff.dart';

import '../repositories/scooter_repository.dart';

class GetAvailableTariffsUsecase {
  final ScooterRepository repository;

  GetAvailableTariffsUsecase(this.repository);

  Future<Result<List<Tariff>>> call(int scooterId) {
    return repository.getAvailableTariffs(scooterId);
  }
}
