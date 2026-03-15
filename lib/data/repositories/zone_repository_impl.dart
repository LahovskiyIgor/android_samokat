import 'package:by_happy/domain/entities/zone.dart';
import 'package:by_happy/domain/repositories/zone_repository.dart';

import '../../domain/entities/point.dart';
import '../network/api_service.dart';

class ZoneRepositoryImpl extends ZoneRepository {
  final ApiService _apiService;

  ZoneRepositoryImpl(this._apiService);

  @override
  Future<List<Zone>> getZones(List<double> area,
      int page,
      int pageSize,) async {

    final List<Point> list = [];
    final List<Point> list2 = [];

    list.add(Point(55.182372,30.203347));
    list.add(Point(55.173746,30.200257));
    list.add(Point(55.172153,30.212531));
    list.add(Point(55.179946,30.215964));

    list2.add(Point(55.178304,30.227380));
    list2.add(Point(55.178059,30.229654));
    list2.add(Point(55.191339,30.234718));
    list2.add(Point(55.194352,30.234890));
    list2.add(Point(55.194377,30.231972));
    list2.add(Point(55.192123,30.232744));

    final zone = Zone(id: 123,
        title: "Zone 01",
        description: "description",
        type: "Finish",
        isActive: true,
        shapeType: "polygon",
        points: list,
        speedLimit: "speedLimit");

    final zone2 = Zone(id: 124,
        title: "Zone 02",
        description: "description",
        type: "NotDrive",
        isActive: true,
        shapeType: "polygon",
        points: list2,
        speedLimit: "speedLimit");


    final responce = await _apiService.getZones(
      area: area,
      page: page,
      pageSize: pageSize,
    );

    final List<Zone>? zones = responce?.zones;
    zones?.add(zone);
    zones?.add(zone2);

    print("Scooters: ${zones?.first.title}");

    if (responce != null) {
      return zones ?? List.empty();
    }

    return List.empty();
  }
}
