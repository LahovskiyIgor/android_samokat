import 'dart:io';

import 'package:by_happy/data/network/api_service.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final ApiService _apiService;

  static const String kAccessToken = "access_token";
  static const String kRefreshToken = "refresh_token";

  final UserProfile _cachedProfile = UserProfile(
    name: 'Иванов Антон',
    birthDate: '12-03-2005',
    phone: '+375 00 000-00-00',
    email: 'почта@gmail.com',
  );

  UserProfileRepositoryImpl(this._apiService);

  @override
  Future<UserProfile> getProfile() async {
    return await _apiService.getProfile() ?? _cachedProfile;
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) async {
    //await Future.delayed(const Duration(milliseconds: 300));
    print("UPDATE PROFILE DATA: $profile");
    return await _apiService.updateProfile(profile) ?? profile;
  }

  @override
  Future<void> uploadProfilePhoto(File imageFile) async {
    await _apiService.uploadPhoto(imageFile);
  }


}
