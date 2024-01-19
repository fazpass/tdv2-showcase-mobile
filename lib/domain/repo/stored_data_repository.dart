
import 'package:tdv2_showcase_mobile/domain/entity/login_detail.dart';

abstract class StoredDataRepository {
  Future<bool> saveLoginDetail(String phone, String fazpassId);
  Future<LoginDetail?> getCurrentLoginDetail();
  Future<bool> removeCurrentLoginDetail();
  Future<bool> isCurrentLoginSetWithHighBiometricLevel();
  Future<int> saveAccount(String phone);
  Future<List<String>> getAccounts();
}