import 'package:by_happy/core/result.dart';
import 'package:by_happy/domain/entities/scooter.dart';

import '../repositories/scooter_repository.dart';


class GetScooterUsecase {
  final ScooterRepository repository;

  GetScooterUsecase(this.repository);

  Future<Result<Scooter?>> call(int id) {
    return repository.getScooter(id);
  }
}

