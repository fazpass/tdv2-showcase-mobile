
import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';
import 'package:tdv2_showcase_mobile/domain/repo/fazpass_repository.dart';

class DeviceFazpassRepository implements FazpassRepository {

  static const _instance = DeviceFazpassRepository._internal();
  const DeviceFazpassRepository._internal();
  factory DeviceFazpassRepository() => _instance;

  @override
  Future<void> initialize(List<dynamic> sensitiveData) async {
    await Fazpass.instance.init('tdv2_showcase_public.pub');
    await Fazpass.instance.enableSelected([]);
    return;
  }

  @override
  Future<String> generateMeta() async {
    return await Fazpass.instance.generateMeta() ?? '';
  }
}