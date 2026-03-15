import 'package:by_happy/data/network/geocoding_remote_datasource.dart';

class GetAddressByPointUsecase {
  final GeocodingRemoteDataSource dataSource;

  GetAddressByPointUsecase(this.dataSource);

  Future<String> call(double latitude, double longitude) {
    return dataSource.getAddressFromPoint(latitude: latitude, longitude: longitude);
  }
}