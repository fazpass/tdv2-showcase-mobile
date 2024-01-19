
import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/repo/fazpass_repository.dart';
import 'package:tdv2_showcase_mobile/domain/repo/stored_data_repository.dart';
import 'package:tdv2_showcase_mobile/exception.dart';

class LogoutUseCase extends OneTimeUseCase<bool, void> {
  LogoutUseCase(StoredDataRepository storedDataRepo, FazpassRepository fazpassRepo)
      : super((params) async {
        final login = await storedDataRepo.getCurrentLoginDetail();
        if (login == null) throw NotLoggedInException();
        final currentSettings = await fazpassRepo.getSettings(accountIndex: login.accountIndex);
        final builder = (currentSettings != null)
            ? FazpassSettingsBuilder.fromFazpassSettings(currentSettings)
            : FazpassSettingsBuilder();
        builder.setBiometricLevelToLow();
        fazpassRepo.setSettings(accountIndex: login.accountIndex, settings: builder.build());
        return storedDataRepo.removeCurrentLoginDetail();
      });
}
