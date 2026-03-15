import 'package:by_happy/domain/entities/user_auth_data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecurityService {
  Future<void> saveTokens(UserAuthData data);
  Future<void> removeTokens();
  Future<String?> getRefreshToken();
  Future<String?> getAccessToken();
  // Future<UserAuthData?> getTokens();
}