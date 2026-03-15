import 'package:by_happy/domain/entities/user_auth_data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/service/security_service.dart';

class SecurityServiceImpl extends SecurityService {
  static const String kAccessToken = "access_token";
  static const String kRefreshToken = "refresh_token";

  final FlutterSecureStorage _secureStorage;

  SecurityServiceImpl(this._secureStorage);

  @override
  Future<void> saveTokens(UserAuthData data) async {
    await _secureStorage.write(key: kAccessToken, value: data.accessToken);
    await _secureStorage.write(key: kRefreshToken, value: data.refreshToken);
  }

  @override
  Future<void> removeTokens() async {
    await _secureStorage.delete(key: kRefreshToken);
    await _secureStorage.delete(key: kAccessToken);
  }

  @override
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: kAccessToken);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: kRefreshToken);
  }

  // @override
  // Future<UserAuthData?> getTokens() async {
  //   final accessToken = await _secureStorage.read(key: kAccessToken);
  //   final refreshToken = await _secureStorage.read(key: kRefreshToken);
  //
  //   if(accessToken != null && refreshToken != null) {
  //       return UserAuthData(
  //       accessToken: accessToken,
  //       refreshToken: refreshToken,
  //     );
  //   }
  //
  //   return null;
  // }
}
