import 'package:by_happy/domain/entities/scooter.dart';

import '../repositories/scooter_repository.dart';


class GetAvailableScootersUsecase {
  final ScooterRepository repository;

  GetAvailableScootersUsecase(this.repository);

  Future<List<Scooter>> call(List<double> area, int page, int pageSize) {
    return repository.getScooters(area, page, pageSize);
  }
}

