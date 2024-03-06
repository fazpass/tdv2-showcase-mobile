
import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';

abstract interface class FazpassRepository {
  Future<void> initialize();
  Future<String> generateMeta({int accountIndex=-1});
  Future<bool> generateSecretKey();
  Future<FazpassSettings?> getSettings({int accountIndex=-1});
  Future<void> setSettings({int accountIndex=-1, FazpassSettings? settings});
  Stream<CrossDeviceRequest> listenToIncomingValidateNotificationRequest();
}