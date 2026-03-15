import 'dart:io';
import '../repositories/profile_repository.dart';

class UploadProfilePhotoUsecase {
  final UserProfileRepository repository;

  UploadProfilePhotoUsecase(this.repository);

  Future<void> call(File imageFile) {
    return repository.uploadProfilePhoto(imageFile);
  }
}