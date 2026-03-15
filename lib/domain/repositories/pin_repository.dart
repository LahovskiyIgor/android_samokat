import '../entities/user_auth_data.dart';

abstract class PinRepository {
  Future<String?> getSavedPin();

  Future<void> savePin(String? pin);
}