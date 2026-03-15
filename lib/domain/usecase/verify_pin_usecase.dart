import 'package:by_happy/domain/repositories/pin_repository.dart';

import '../repositories/auth_repository.dart';

class VerifyPinUseCase {
  final PinRepository repository;

  VerifyPinUseCase(this.repository);

  Future<bool> call(String enteredPin) async {
    final savedPin = await repository.getSavedPin();
    return enteredPin == savedPin;
  }
}

