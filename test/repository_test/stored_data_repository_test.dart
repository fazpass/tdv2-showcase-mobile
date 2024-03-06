

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdv2_showcase_mobile/device/repo/stored_data_repository.dart';

@GenerateNiceMocks([
  MockSpec<DeviceStoredDataRepository>(),
  MockSpec<SharedPreferences>()
])
import 'stored_data_repository_test.mocks.dart';

const phone = '1234567890';
const fazpassId = 'fazpassId';

void main() {
  final storedDataRepo = MockDeviceStoredDataRepository();
  final prefs = MockSharedPreferences();

  setUp(() {
    when(storedDataRepo.getPreferences()).thenAnswer((_) async => prefs);
  });

  tearDown(() {
    reset(storedDataRepo);
    reset(prefs);
  });

  test('account index test', () async {
    const predefinedAccount = '000000000000';

    when(storedDataRepo.saveAccount(phone)).thenAnswer((_) async {
      final accounts = await storedDataRepo.getAccounts();
      if (!accounts.contains(phone)) {
        accounts.add(phone);

        prefs.setStringList(DeviceStoredDataRepository.keyAccountList, accounts);
      }
      return accounts.indexOf(phone);
    });
    when(storedDataRepo.getAccounts()).thenAnswer((_) async => [predefinedAccount]);

    await expectLater(storedDataRepo.saveAccount(phone), completion(1));

    verifyInOrder([
      storedDataRepo.getAccounts(),
      prefs.setStringList(DeviceStoredDataRepository.keyAccountList, [predefinedAccount, phone]),
    ]);
  });
}