
import '../entities/zone.dart';
import '../repositories/zone_repository.dart';


class GetAvailableZonesUsecase {
  final ZoneRepository repository;

  GetAvailableZonesUsecase(this.repository);

  Future<List<Zone>?> call(List<double> area, int page, int pageSize) {
    return repository.getZones(area, page, pageSize);
  }
}

