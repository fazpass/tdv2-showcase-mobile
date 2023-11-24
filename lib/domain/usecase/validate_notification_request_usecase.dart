
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/repo/fazpass_repository.dart';
import 'package:tdv2_showcase_mobile/domain/repo/home_repository.dart';

class ValidateNotificationRequestUseCase extends OneTimeUseCase<bool, ValidateNotificationRequestUseCaseParams> {
  ValidateNotificationRequestUseCase(HomeRepository homeRepo, FazpassRepository fazpassRepo)
      : super((params) async {
        final meta = await fazpassRepo.generateMeta();
        return homeRepo.validateNotification(meta, params!.receiverId, params.answer);
  });
}

class ValidateNotificationRequestUseCaseParams {
  final String receiverId;
  final bool answer;

  ValidateNotificationRequestUseCaseParams(this.receiverId, this.answer);
}