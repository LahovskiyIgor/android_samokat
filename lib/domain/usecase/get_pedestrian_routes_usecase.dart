import 'package:by_happy/data/network/geocoding_remote_datasource.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class GetPedestrianRoutesUsecase {
  final GeocodingRemoteDataSource dataSource;

  GetPedestrianRoutesUsecase(this.dataSource);

  Future<List<MasstransitRoute>?> call(Point userPosition, Point targetPosition) {
    return dataSource.getPedestrianRoutes(userPosition, targetPosition);
  }
}