import 'package:tdv2_showcase_mobile/domain/repo/fazpass_repository.dart';
import 'package:tdv2_showcase_mobile/domain/repo/home_repository.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';

class RemoveDeviceUseCase extends OneTimeUseCase<bool, void> {
  RemoveDeviceUseCase(HomeRepository homeRepo, FazpassRepository fazpassRepo)
      : super((params) async {
        final meta = await fazpassRepo.generateMeta();
        return homeRepo.removeDevice(meta);
      });
}
