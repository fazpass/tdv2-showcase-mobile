
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/repo/fazpass_repository.dart';
import 'package:tdv2_showcase_mobile/domain/repo/login_repository.dart';

class InitializeAppUseCase extends OneTimeUseCase<bool, void> {

  static var hasInitialized = false;

  InitializeAppUseCase(LoginRepository loginRepo, FazpassRepository fazpassRepo)
      : super((params) async {
        if (!hasInitialized) {
          await fazpassRepo.initialize();
          hasInitialized = true;
        }
        return await loginRepo.isLoggedIn();
      });
}