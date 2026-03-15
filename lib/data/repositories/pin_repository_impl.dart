import 'package:by_happy/domain/repositories/pin_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinRepositoryImpl implements PinRepository {
  final FlutterSecureStorage _storage;

  PinRepositoryImpl(this._storage);

  @override
  Future<String?> getSavedPin() {
    return _storage.read(key: "user_pin");
  }

  @override
  Future<void> savePin(String? pin) async {
    await _storage.write(key: "user_pin", value: pin);
  }

}