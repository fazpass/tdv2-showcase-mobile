
import 'dart:async';

import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';
import 'package:tdv2_showcase_mobile/domain/repo/fazpass_repository.dart';

class DeviceFazpassRepository implements FazpassRepository {

  static const _instance = DeviceFazpassRepository._internal();
  const DeviceFazpassRepository._internal();
  factory DeviceFazpassRepository() => _instance;

  @override
  Future<void> initialize() async {
    await Fazpass.instance.init(
        androidAssetName: 'new-public-key.pub',
        iosAssetName: 'tdv2_showcase_public.pub',
        iosFcmAppId: '1:762638394860:ios:19b19305e8ae6a4dc90cc9'
    );
  }

  @override
  Future<String> generateMeta({int accountIndex=-1}) async {
    return Fazpass.instance.generateMeta(accountIndex: accountIndex);
  }

  @override
  Future<bool> generateSecretKey() async {
    await Fazpass.instance.generateNewSecretKey();
    return true;
  }

  @override
  Future<FazpassSettings?> getSettings({int accountIndex=-1}) async {
    return Fazpass.instance.getSettings(accountIndex);
  }

  @override
  Future<void> setSettings({int accountIndex=-1, FazpassSettings? settings}) async {
    return Fazpass.instance.setSettings(accountIndex, settings);
  }

  @override
  Stream<CrossDeviceRequest> listenToIncomingValidateNotificationRequest() {
    final controller = StreamController<CrossDeviceRequest>();
    Fazpass.instance.getCrossDeviceRequestFromNotification().then((value) {
      if (value != null) controller.add(value);
      controller.addStream(Fazpass.instance.getCrossDeviceRequestStreamInstance());
    });
    return controller.stream;
  }
}