import 'package:by_happy/domain/entities/map_settings.dart';

abstract class AppSettingsRepository {

  Future<MapSettings> getMapSettings();
  Future<void> saveMapSettings(MapSettings settings);
}