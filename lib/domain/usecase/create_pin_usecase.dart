import 'package:by_happy/domain/repositories/pin_repository.dart';

import '../repositories/auth_repository.dart';

class CreatePinUseCase {
  final PinRepository repository;

  CreatePinUseCase(this.repository);

  Future<void> call(String pin) async {
    _validate(pin);

    final hashed = _hash(pin);
    await repository.savePin(hashed);
  }

  void _validate(String pin) {
    if (pin.length != 6) {
      throw Exception('PIN must be 6 digits');
    }
  }

  String _hash(String pin) {
    // временно просто pin
    return pin;
  }
}
