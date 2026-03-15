import 'dart:async';

import 'package:yandex_mapkit/yandex_mapkit.dart';

class GeocodingRemoteDataSource {

  Future<String> getAddressFromPoint({
    required double latitude,
    required double longitude,
  }) async {
    final point = Point(
      latitude: latitude,
      longitude: longitude,
    );

    final (session, resultFuture) = await YandexSearch.searchByPoint(
      point: point,
      zoom: 16,
      searchOptions: const SearchOptions(
        searchType: SearchType.geo,
        resultPageSize: 1,
      ),
    );

    try {
      final result = await resultFuture;

      if (result.items == null || result.items!.isEmpty) {
        throw Exception("Адрес не найден");
      }

      final item = result.items!.first;

      print("ADDRESS FETCH RESULT ${item.name}");

      final toponymAddress =
          item.toponymMetadata?.address?.formattedAddress;

      if (toponymAddress != null && toponymAddress.isNotEmpty) {
        return toponymAddress;
      }

      final businessAddress =
          item.businessMetadata?.address?.formattedAddress;

      if (businessAddress != null && businessAddress.isNotEmpty) {
        return businessAddress;
      }

      return item.name;
    } catch (e) {
      throw Exception("Ошибка получения адреса: $e");
    } finally {
      await session.close();
    }
  }

  Future<List<MasstransitRoute>?> getPedestrianRoutes(Point userPosition,
      Point targetPosition) async {
    final (session, resultFuture) = await YandexPedestrian.requestRoutes(
        points: [
          RequestPoint(
              point: userPosition, requestPointType: RequestPointType.wayPoint),
          RequestPoint(point: targetPosition,
              requestPointType: RequestPointType.wayPoint)
        ],
        fitnessOptions: FitnessOptions(avoidSteep: false, avoidStairs: false),
        timeOptions: TimeOptions()
    );

    try {
      final result = await resultFuture;

      final distance = result.routes?.first.metadata.weight.walkingDistance.value;

      print("Дистанция до самоката: $distance");

      return result.routes;

    } catch (e) {
      print('Error: $e');
    }
    return null;

  }
}