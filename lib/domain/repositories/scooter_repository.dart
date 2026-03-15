
import '../../core/result.dart';
import '../entities/scooter.dart';

abstract class ScooterRepository {
  Future<List<Scooter>> getScooters(List<double> area, int page, int pageSize);
  Future<Result<Scooter?>> getScooter(int id);
}
