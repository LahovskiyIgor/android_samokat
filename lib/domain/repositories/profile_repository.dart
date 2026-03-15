import 'dart:io';

import '../entities/user_profile.dart';

abstract class UserProfileRepository {
  Future<UserProfile> getProfile();
  Future<void> updateProfile(UserProfile profile);
  Future<void> uploadProfilePhoto(File imageFile);
}

