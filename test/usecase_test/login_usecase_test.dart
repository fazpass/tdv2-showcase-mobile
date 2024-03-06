
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdv2_showcase_mobile/data/repo/home_repository.dart';
import 'package:tdv2_showcase_mobile/data/repo/login_repository.dart';
import 'package:tdv2_showcase_mobile/device/repo/fazpass_repository.dart';
import 'package:tdv2_showcase_mobile/device/repo/stored_data_repository.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_observer.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/login_usecase.dart';

@GenerateNiceMocks([
  MockSpec<DeviceStoredDataRepository>(),
  MockSpec<DeviceFazpassRepository>(),
  MockSpec<DataHomeRepository>(),
  MockSpec<DataLoginRepository>()
])
import 'login_usecase_test.mocks.dart';

const phone = '081234567890';

void main() {
  final loginRepo = MockDataLoginRepository();
  final fazpassRepo = MockDeviceFazpassRepository();
  final storedDataRepo = MockDeviceStoredDataRepository();

  tearDown(() {
    reset(loginRepo);
    reset(fazpassRepo);
    reset(storedDataRepo);
  });

  test('success login instantly test', () async {
    when(fazpassRepo.generateMeta()).thenAnswer((_) async => 'meta');
    when(loginRepo.login(phone, 'meta')).thenAnswer((_) async => LoginUseCaseResponse(true, 'meta', [], 'challenge', fazpassId: 'fazpassId'));
    when(storedDataRepo.saveLoginDetail(phone, 'fazpassId')).thenAnswer((_) async => true);

    final useCaseCompleter = Completer<bool>();
    LoginUseCase(loginRepo, fazpassRepo, storedDataRepo)
        .execute(OneTimeObserver(
            (success) {
          useCaseCompleter.complete(success.canLoginInstantly);
        },
            (e) {
          useCaseCompleter.complete(false);
        }
    ), phone);

    await expectLater(useCaseCompleter.future, completion(true));
  });
}