import 'package:by_happy/domain/repositories/scooter_repository.dart';

import '../../core/failures.dart';
import '../../core/result.dart';
import '../../domain/entities/scooter.dart';
import '../exceptions/auth_exception.dart';
import '../network/api_service.dart';

class ScooterRepositoryImpl extends ScooterRepository {
  final ApiService _apiService;

  final scooter = Scooter(
    id: 123,
    title: "Unnamed",
    status: "Available",
    latitude: 55.178960,
    longitude: 30.222316,
    batteryLevel: 89,
    isOnline: true,
    maxSpeed: 25,
    number: "Unnamed",
  );

  ScooterRepositoryImpl(this._apiService);

  @override
  Future<List<Scooter>> getScooters(
    List<double> area,
    int page,
    int pageSize,
  ) async {
    final responce = await _apiService.getScooters(
      area: area,
      page: page,
      pageSize: pageSize,
    );

    final List<Scooter>? list = responce?.scooters;
    // list?.add(scooter);

    // print("Scooters: ${list?.first.status}");

    if (responce != null) {
      return list ?? List.empty();
    }

    return List.empty();
  }

  @override
  Future<Result<Scooter?>> getScooter(int id) async {

    late final Result<Scooter> result;
    try {
      final scooter = await _apiService.getScooterById(id: id);
      if (scooter != null) {
        result = Success(scooter);
      }
    } on AuthException catch (e) {
      result = Failure(AuthFailure(e.attemptsLeft));
    } catch (e) {
      result = Failure(UnknownFailure());
    }
    return result;
  }





}
