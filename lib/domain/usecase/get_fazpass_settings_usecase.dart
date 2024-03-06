
import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/repo/fazpass_repository.dart';
import 'package:tdv2_showcase_mobile/domain/repo/stored_data_repository.dart';
import 'package:tdv2_showcase_mobile/exception.dart';

class GetFazpassSettingsUseCase extends OneTimeUseCase<FazpassSettings?, void> {
  GetFazpassSettingsUseCase(FazpassRepository fazpassRepo, StoredDataRepository storedDataRepo)
      : super((params) async {
        final login = await storedDataRepo.getCurrentLoginDetail();
        if (login == null) throw NotLoggedInException();
        return fazpassRepo.getSettings(accountIndex: login.accountIndex);
      });
}