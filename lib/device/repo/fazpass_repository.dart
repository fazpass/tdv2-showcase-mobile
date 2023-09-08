
import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';
import 'package:tdv2_showcase_mobile/domain/repo/fazpass_repository.dart';

class DeviceFazpassRepository implements FazpassRepository {

  static const _instance = DeviceFazpassRepository._internal();
  const DeviceFazpassRepository._internal();
  factory DeviceFazpassRepository() => _instance;

  @override
  Future<void> initialize(String assetName) async {
    await Fazpass.instance.init(assetName);
  }

  @override
  Future<String> generateMeta() async {
    return await Fazpass.instance.generateMeta();
  }

  @override
  Future<void> enableSelected(List<SensitiveData> sensitiveData) async {
    await Fazpass.instance.enableSelected(sensitiveData);
  }
}