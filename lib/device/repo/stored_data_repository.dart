
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdv2_showcase_mobile/domain/entity/login_detail.dart';
import 'package:tdv2_showcase_mobile/domain/repo/stored_data_repository.dart';
import 'package:tdv2_showcase_mobile/exception.dart';

class DeviceStoredDataRepository implements StoredDataRepository {

  static const keyAccountList = 'accounts';
  static const keyPhone = 'phone';
  static const keyFazpassId = 'fazpass_id';
  static const keyAccountIndex = 'account_index';
  static const keyHighLevelBiometric = 'high_lvl_bio';
  static const keyIsLoggedIn = 'is_logged_in';

  static const _instance = DeviceStoredDataRepository._internal();
  const DeviceStoredDataRepository._internal();
  factory DeviceStoredDataRepository() => _instance;

  Future<SharedPreferences> getPreferences() =>
      SharedPreferences.getInstance();

  @override
  Future<bool> saveLoginDetail(String phone, String fazpassId) async {
    final prefs = await getPreferences();
    final accountIndex = await saveAccount(phone);

    final tasks = [
      await prefs.setString(keyPhone, phone),
      await prefs.setString(keyFazpassId, fazpassId),
      await prefs.setInt(keyAccountIndex, accountIndex),
      await prefs.setBool(keyIsLoggedIn, true)
    ];
    return tasks.every((isTaskSuccess) => isTaskSuccess);
  }

  @override
  Future<LoginDetail?> getCurrentLoginDetail() async {
    final prefs = await getPreferences();

    if (prefs.getBool(keyIsLoggedIn) != true) return null;

    final data = [
      prefs.getString(keyPhone),
      prefs.getString(keyFazpassId),
      prefs.getInt(keyAccountIndex),
    ];

    if (data.every((element) => element != null)) {
      return LoginDetail(
        phone: data[0] as String,
        fazpassId: data[1] as String,
        accountIndex: data[2] as int,
      );
    }
    return null;
  }

  @override
  Future<bool> removeCurrentLoginDetail() async {
    final prefs = await getPreferences();

    final tasks = [
      await prefs.remove(keyPhone),
      await prefs.remove(keyFazpassId),
      await prefs.remove(keyAccountIndex),
      await prefs.remove(keyIsLoggedIn),
      await prefs.remove(keyHighLevelBiometric)
    ];
    return tasks.every((isTaskSuccess) => isTaskSuccess);
  }

  @override
  Future<bool> isCurrentLoginSetWithHighBiometricLevel() async {
    final prefs = await getPreferences();

    if (prefs.getBool(keyIsLoggedIn) != true) throw NotLoggedInException();

    final isHighLevelBiometric = prefs.getBool(keyHighLevelBiometric) ?? false;
    if (!isHighLevelBiometric) prefs.setBool(keyHighLevelBiometric, true);
    return isHighLevelBiometric;
  }

  @override
  Future<int> saveAccount(String phone) async {
    final accounts = await getAccounts();
    if (!accounts.contains(phone)) {
      accounts.add(phone);

      final prefs = await getPreferences();
      prefs.setStringList(keyAccountList, accounts);
    }
    return accounts.indexOf(phone);
  }

  @override
  Future<List<String>> getAccounts() async {
    final prefs = await getPreferences();
    return [...?prefs.getStringList(keyAccountList)];
  }
}