
import '../../core/result.dart';
import '../entities/scooter.dart';
import '../entities/tariff.dart';
import '../entities/scooter_order.dart';

abstract class ScooterRepository {
  Future<List<Scooter>> getScooters(List<double> area, int page, int pageSize);
  Future<Result<Scooter?>> getScooter(int id);
  Future<Result<List<Tariff>>> getAvailableTariffs(int scooterId);
  Future<Result<ScooterOrder>> bookScooter({
    required int scooterId,
    required int planId,
    int? subscriptionId,
    int? cardId,
    required bool isBalance,
    required bool isInsurance,
  });
  Future<Result<ScooterOrder>> startRide(int orderId);
  Future<Result<ScooterOrder>> cancelRide(int orderId);
  Future<Result<ScooterOrder>> pauseRide(int orderId);
  Future<Result<ScooterOrder>> resumeRide(int orderId);
  Future<Result<ScooterOrder>> finishRide(int orderId);
  Future<Result<ScooterOrder>> payRide(int orderId);
  Future<Result<List<ScooterOrder>>> getClientOrders();
  Future<Result<List<int>>> uploadScooterPhotos(List<File> images);
  Future<Result<ScooterOrder>> updateScooterOrderData({
    required int orderId,
    Map<String, dynamic>? data,
  });
  Future<Result<ScooterOrder>> payScooterOrderWithPhotos({
    required int orderId,
    required List<int> filesId,
  });
  Future<Result<ScooterOrder>> getScooterOrderById(int id);
}
