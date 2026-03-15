import '../entities/zone.dart';

abstract class ZoneRepository {
  Future<List<Zone>> getZones(List<double> area, int page, int pageSize);
}

