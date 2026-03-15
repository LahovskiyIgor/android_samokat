import 'package:by_happy/domain/repositories/pin_repository.dart';

import '../repositories/auth_repository.dart';

class ChangePinUseCase {
  final PinRepository repository;

  ChangePinUseCase(this.repository);

  Future<void> call({
    required String oldPin,
    required String newPin,
  }) async {
    final savedPin = await repository.getSavedPin();

    if (savedPin != oldPin) {
      throw Exception('Wrong old PIN');
    }

    if (newPin.length != 6) {
      throw Exception('Invalid new PIN');
    }

    await repository.savePin(newPin);
  }
}

