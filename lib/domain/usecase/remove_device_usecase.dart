
import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';
import 'package:tdv2_showcase_mobile/domain/repo/fazpass_repository.dart';
import 'package:tdv2_showcase_mobile/domain/repo/home_repository.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/repo/stored_data_repository.dart';
import 'package:tdv2_showcase_mobile/exception.dart';

class RemoveDeviceUseCase extends OneTimeUseCase<bool, void> {
  RemoveDeviceUseCase(HomeRepository homeRepo, FazpassRepository fazpassRepo, StoredDataRepository storedDataRepo)
      : super((params) async {
        final login = await storedDataRepo.getCurrentLoginDetail();
        if (login == null) throw NotLoggedInException();
        final meta = await fazpassRepo.generateMeta(accountIndex: login.accountIndex);
        final status = await homeRepo.removeDevice(login, meta);
        if (status) {
          final currentSettings = await fazpassRepo.getSettings(accountIndex: login.accountIndex);
          final builder = (currentSettings != null)
              ? FazpassSettingsBuilder.fromFazpassSettings(currentSettings)
              : FazpassSettingsBuilder();
          builder.setBiometricLevelToLow();
          fazpassRepo.setSettings(accountIndex: login.accountIndex, settings: builder.build());
          return storedDataRepo.removeCurrentLoginDetail();
        }
        return false;
      });
}
