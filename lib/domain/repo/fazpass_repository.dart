
import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';
import 'package:flutter_trusted_device_v2/src/cross_device_request.dart';

abstract interface class FazpassRepository {
  Future<void> initialize(String assetName);
  Future<void> enableSelected(List<SensitiveData> sensitiveData);
  Future<String> generateMeta();
  Stream<CrossDeviceRequest> listenToIncomingValidateNotificationRequest();
}