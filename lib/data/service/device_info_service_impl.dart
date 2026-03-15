import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../../domain/service/device_info_service.dart';

class DeviceInfoServiceImpl extends DeviceInfoService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final AndroidId _androidId = const AndroidId();

  @override
  Future<String> getDeviceModel() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return '${androidInfo.manufacturer} ${androidInfo.model}';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.utsname.machine;
      }
    } catch (e) {
      print("ERROR: $e");
    }
    return 'Unknown';
  }

  @override
  Future<String?> getSystemId() async {
    try {
      if (Platform.isAndroid) {
        return await _androidId.getId();
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.identifierForVendor;
      }
    } catch (e) {
      print("ERROR: $e");
      return null;
    }
    return null;
  }
}
