
import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/repo/fazpass_repository.dart';
import 'package:tdv2_showcase_mobile/domain/repo/stored_data_repository.dart';
import 'package:tdv2_showcase_mobile/exception.dart';

class SetFazpassSettingsUseCase extends OneTimeUseCase<bool, FazpassSettings?> {
  SetFazpassSettingsUseCase(FazpassRepository fazpassRepo, StoredDataRepository storedDataRepo)
      : super((params) async {
        final login = await storedDataRepo.getCurrentLoginDetail();
        if (login == null) throw NotLoggedInException();
        fazpassRepo.setSettings(accountIndex: login.accountIndex, settings: params);
        if (params != null && params.isBiometricLevelHigh) {
          final isBiometricLevelHigh = await storedDataRepo.isCurrentLoginSetWithHighBiometricLevel();
          if (!isBiometricLevelHigh) {
            return await fazpassRepo.generateSecretKey();
          }
        }
        return true;
      });
}
