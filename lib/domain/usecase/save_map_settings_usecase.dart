import 'package:by_happy/domain/entities/map_settings.dart';

import '../repositories/app_settings_repository.dart';

class SaveMapSettingsUsecase {
  AppSettingsRepository repository;

  SaveMapSettingsUsecase(this.repository);

  Future<void> call(MapSettings settings) {
    return repository.saveMapSettings(settings);
  }
}