import 'package:by_happy/domain/repositories/scooter_repository.dart';

import '../../core/failures.dart';
import '../../core/result.dart';
import '../../domain/entities/scooter.dart';
import '../../domain/entities/tariff.dart';
import '../../domain/entities/scooter_order.dart';
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

  @override
  Future<Result<List<Tariff>>> getAvailableTariffs(int scooterId) async {
    late final Result<List<Tariff>> result;
    try {
      final response = await _apiService.getAvailableTariffs(scooterId: scooterId);
      if (response != null) {
        result = Success(response.tariffs);
      } else {
        result = Failure(UnknownFailure());
      }
    } catch (e) {
      result = Failure(UnknownFailure());
    }
    return result;
  }

  @override
  Future<Result<ScooterOrder>> bookScooter({
    required int scooterId,
    required int planId,
    int? subscriptionId,
    int? cardId,
    required bool isBalance,
    required bool isInsurance,
  }) async {
    late final Result<ScooterOrder> result;
    try {
      final order = await _apiService.bookScooter(
        scooterId: scooterId,
        planId: planId,
        subscriptionId: subscriptionId,
        cardId: cardId,
        isBalance: isBalance,
        isInsurance: isInsurance,
      );
      if (order != null) {
        result = Success(order);
      } else {
        result = Failure(UnknownFailure());
      }
    } on AuthException catch (e) {
      result = Failure(AuthFailure(e.attemptsLeft));
    } catch (e) {
      result = Failure(UnknownFailure());
    }
    return result;
  }

  @override
  Future<Result<ScooterOrder>> startRide(int orderId) async {
    late final Result<ScooterOrder> result;
    try {
      final order = await _apiService.startRide(orderId);
      if (order != null) {
        result = Success(order);
      } else {
        result = Failure(UnknownFailure());
      }
    } on AuthException catch (e) {
      result = Failure(AuthFailure(e.attemptsLeft));
    } catch (e) {
      result = Failure(UnknownFailure());
    }
    return result;
  }

  @override
  Future<Result<ScooterOrder>> cancelRide(int orderId) async {
    late final Result<ScooterOrder> result;
    try {
      final order = await _apiService.cancelRide(orderId);
      if (order != null) {
        result = Success(order);
      } else {
        result = Failure(UnknownFailure());
      }
    } on AuthException catch (e) {
      result = Failure(AuthFailure(e.attemptsLeft));
    } catch (e) {
      result = Failure(UnknownFailure());
    }
    return result;
  }

  @override
  Future<Result<ScooterOrder>> pauseRide(int orderId) async {
    late final Result<ScooterOrder> result;
    try {
      final order = await _apiService.pauseRide(orderId);
      if (order != null) {
        result = Success(order);
      } else {
        result = Failure(UnknownFailure());
      }
    } on AuthException catch (e) {
      result = Failure(AuthFailure(e.attemptsLeft));
    } catch (e) {
      result = Failure(UnknownFailure());
    }
    return result;
  }

  @override
  Future<Result<ScooterOrder>> resumeRide(int orderId) async {
    late final Result<ScooterOrder> result;
    try {
      final order = await _apiService.resumeRide(orderId);
      if (order != null) {
        result = Success(order);
      } else {
        result = Failure(UnknownFailure());
      }
    } on AuthException catch (e) {
      result = Failure(AuthFailure(e.attemptsLeft));
    } catch (e) {
      result = Failure(UnknownFailure());
    }
    return result;
  }

  @override
  Future<Result<ScooterOrder>> finishRide(int orderId) async {
    late final Result<ScooterOrder> result;
    try {
      final order = await _apiService.finishRide(orderId);
      if (order != null) {
        result = Success(order);
      } else {
        result = Failure(UnknownFailure());
      }
    } on AuthException catch (e) {
      result = Failure(AuthFailure(e.attemptsLeft));
    } catch (e) {
      result = Failure(UnknownFailure());
    }
    return result;
  }

  @override
  Future<Result<ScooterOrder>> payRide(int orderId) async {
    late final Result<ScooterOrder> result;
    try {
      final order = await _apiService.payRide(orderId);
      if (order != null) {
        result = Success(order);
      } else {
        result = Failure(UnknownFailure());
      }
    } on AuthException catch (e) {
      result = Failure(AuthFailure(e.attemptsLeft));
    } catch (e) {
      result = Failure(UnknownFailure());
    }
    return result;
  }
}
