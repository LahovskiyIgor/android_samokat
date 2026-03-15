import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsService {
  final SharedPreferences sharedPreferences;

  AppSettingsService(this.sharedPreferences);

  Future<void> saveMapSettingsFlag(String key, bool value) async {
    sharedPreferences.setBool(key, value);
  }

  bool getMapSettingsFlag(String key) {
    return sharedPreferences.getBool(key) ?? false;
  }
}
