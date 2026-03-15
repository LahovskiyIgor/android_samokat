import 'package:by_happy/core/failures.dart';
import 'package:by_happy/core/result.dart';
import 'package:by_happy/data/exceptions/auth_block_exception.dart';
import 'package:by_happy/data/exceptions/auth_exception.dart';
import 'package:by_happy/domain/service/device_info_service.dart';
import 'package:by_happy/domain/service/security_service.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_auth_data.dart';

import '../network/api_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService;
  final DeviceInfoService _deviceInfoService;
  final SecurityService _securityService;

  String tempToken = "";

  AuthRepositoryImpl(
    this._apiService,
    this._deviceInfoService,
    this._securityService,
  );

  @override
  Future<String> login(String phone) async {
    final systemId = await _deviceInfoService.getSystemId() ?? "UnknownId";
    final deviceModel = await _deviceInfoService.getDeviceModel();

    final response = await _apiService.sendPhone(phone, deviceModel, systemId);
    if (response != null) {
      tempToken = response;
      print("TEMP TOKEN IS $tempToken");
      return response;
    } else {
      throw Exception("Login failed");
    }
  }

  @override
  Future<Result<void>> verifyCode(String code, String token) async {
    late final Result<UserAuthData> result;
    try {
      final response = await _apiService.verifyCode(code, tempToken);
      if (response != null) {
        final authData = UserAuthData(
          accessToken: response["accessToken"]!,
          refreshToken: response["refreshToken"]!,
        );
        await _securityService.saveTokens(authData);
        result = Success(null);
      }
    } on AuthException catch (e) {
      result = Failure(AuthFailure(e.attemptsLeft));
    } on AuthBlockException {
      result = Failure(AuthBlockFailure());
    } catch (e) {
      result = Failure(UnknownFailure());
    }
    return result;
  }

  @override
  Future<UserAuthData> refreshToken() async {
    final response = await _apiService.refresh();
    print("REFRESH: $response");
    if (response != null) {
      final authData = UserAuthData(
        accessToken: response["accessToken"]!,
        refreshToken: response["refreshToken"]!,
      );
      await _securityService.saveTokens(authData);
      return authData;
    } else {
      throw Exception("Refresh token failed");
    }
  }

  @override
  Future<void> logout() async {
    await _securityService.removeTokens();
  }
}
