
import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/repo/fazpass_repository.dart';
import 'package:tdv2_showcase_mobile/domain/repo/login_repository.dart';

class InitializeAppUseCase extends OneTimeUseCase<bool, InitializeAppUseCaseParams> {
  InitializeAppUseCase(LoginRepository loginRepo, FazpassRepository fazpassRepo)
      : super((params) async {
        await fazpassRepo.initialize(params!.assetName);
        await fazpassRepo.enableSelected(params.enabledSensitiveData);
        return await loginRepo.isLoggedIn();
      });
}

class InitializeAppUseCaseParams {
  final String assetName;
  final List<SensitiveData> enabledSensitiveData;

  InitializeAppUseCaseParams(this.assetName, this.enabledSensitiveData);
}