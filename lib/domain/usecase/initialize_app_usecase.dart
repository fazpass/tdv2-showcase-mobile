
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/repo/fazpass_repository.dart';
import 'package:tdv2_showcase_mobile/domain/repo/login_repository.dart';

class InitializeAppUseCase extends OneTimeUseCase<bool, InitializeAppUseCaseParams> {
  InitializeAppUseCase(LoginRepository loginRepo, FazpassRepository fazpassRepo)
      : super((params) async {
        await fazpassRepo.initialize(
            androidAssetName: params!.androidAssetName,
            iosAssetName: params.iosAssetName,
            iosFcmAppId: params.iosFcmAppId);
        return await loginRepo.isLoggedIn();
      });
}

class InitializeAppUseCaseParams {
  final String androidAssetName;
  final String iosAssetName;
  final String iosFcmAppId;

  InitializeAppUseCaseParams(this.androidAssetName, this.iosAssetName,
      this.iosFcmAppId);
}