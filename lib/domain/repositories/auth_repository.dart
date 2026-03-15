import 'dart:ffi';

import '../../core/result.dart';
import '../entities/user_auth_data.dart';

abstract class AuthRepository {
  Future<String> login(String phone);

  Future<Result<void>> verifyCode(String code, String token);

  Future<UserAuthData> refreshToken();

  Future<void> logout();
}
