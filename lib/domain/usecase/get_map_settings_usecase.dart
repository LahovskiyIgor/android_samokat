import 'package:by_happy/domain/entities/map_settings.dart';
import 'package:by_happy/domain/repositories/app_settings_repository.dart';

class GetMapSettingsUsecase {
  AppSettingsRepository repository;

  GetMapSettingsUsecase(this.repository);

  Future<MapSettings> call() {
    return repository.getMapSettings();
  }
}