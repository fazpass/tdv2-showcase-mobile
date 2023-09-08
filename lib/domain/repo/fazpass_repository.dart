
import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';

abstract interface class FazpassRepository {
  Future<void> initialize(String assetName);
  Future<void> enableSelected(List<SensitiveData> sensitiveData);
  Future<String> generateMeta();
}