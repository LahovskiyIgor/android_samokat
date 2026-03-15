import 'package:by_happy/data/service/app_setting_service.dart';
import 'package:by_happy/domain/entities/map_settings.dart';
import 'package:by_happy/domain/repositories/app_settings_repository.dart';

class AppSettingsRepositoryImpl extends AppSettingsRepository {
  static const String SHOW_ALL_PLACEMARKS = "all_placemarks";
  static const String SHOW_ALL_ZONES = "all_zones";
  static const String SHOW_PARKING_ZONES = "parking_zones";
  static const String SHOW_RESTRICTED_PARKING_ZONES = "restricted_parking_zones";
  static const String SHOW_RESTRICTED_DRIVING_ZONES = "restricted_driving_zones";

  final AppSettingsService appSettingsService;

  AppSettingsRepositoryImpl(this.appSettingsService);

  @override
  Future<MapSettings> getMapSettings() async {
    MapSettings settings = MapSettings(
        all_placemarks: appSettingsService.getMapSettingsFlag(
            SHOW_ALL_PLACEMARKS),
        all_zones: appSettingsService.getMapSettingsFlag(
            SHOW_ALL_ZONES),
        parking_zones: appSettingsService.getMapSettingsFlag(
            SHOW_PARKING_ZONES),
        restricted_parking_zones: appSettingsService.getMapSettingsFlag(
            SHOW_RESTRICTED_PARKING_ZONES),
        restricted_driving_zones: appSettingsService.getMapSettingsFlag(
            SHOW_RESTRICTED_DRIVING_ZONES)
    );

    return settings;
  }

  @override
  Future<void> saveMapSettings(MapSettings settings) async {
    appSettingsService.saveMapSettingsFlag(SHOW_ALL_PLACEMARKS, settings.all_placemarks);
    appSettingsService.saveMapSettingsFlag(SHOW_ALL_ZONES, settings.all_zones);
    appSettingsService.saveMapSettingsFlag(SHOW_PARKING_ZONES, settings.parking_zones);
    appSettingsService.saveMapSettingsFlag(SHOW_RESTRICTED_PARKING_ZONES, settings.restricted_parking_zones);
    appSettingsService.saveMapSettingsFlag(SHOW_RESTRICTED_DRIVING_ZONES, settings.restricted_driving_zones);
  }
}
