import 'dart:io';
import 'package:by_happy/core/result.dart';
import '../repositories/scooter_repository.dart';

class UploadScooterPhotosUsecase {
  final ScooterRepository repository;

  UploadScooterPhotosUsecase(this.repository);

  Future<Result<List<int>>> call(List<File> images) {
    return repository.uploadScooterPhotos(images);
  }
}
