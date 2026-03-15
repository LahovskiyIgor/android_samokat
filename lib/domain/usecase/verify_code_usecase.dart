import 'package:by_happy/core/result.dart';

import '../entities/user_auth_data.dart';
import '../repositories/auth_repository.dart';

class VerifyCodeUseCase {
  final AuthRepository _repository;

  VerifyCodeUseCase(this._repository);

  Future<Result<void>> execute(String code, String token) {
    return _repository.verifyCode(code, token);
  }
}