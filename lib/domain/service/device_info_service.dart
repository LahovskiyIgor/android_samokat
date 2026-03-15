abstract class DeviceInfoService {
  Future<String?> getSystemId();      //SSAID - Android, IDFV - iOS (Vendor ID - один идентификатор для всех приложений одного разработчика, уникальный для одного устройства)
  Future<String> getDeviceModel();
}