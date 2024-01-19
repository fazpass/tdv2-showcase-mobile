
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/repo/fazpass_repository.dart';
import 'package:tdv2_showcase_mobile/domain/repo/home_repository.dart';
import 'package:tdv2_showcase_mobile/domain/repo/stored_data_repository.dart';
import 'package:tdv2_showcase_mobile/exception.dart';

class ValidateNotificationRequestUseCase extends OneTimeUseCase<bool, ValidateNotificationRequestUseCaseParams> {
  ValidateNotificationRequestUseCase(HomeRepository homeRepo, FazpassRepository fazpassRepo, StoredDataRepository storedDataRepo)
      : super((params) async {
        final login = await storedDataRepo.getCurrentLoginDetail();
        if (login == null) throw NotLoggedInException();
        final meta = await fazpassRepo.generateMeta(accountIndex: login.accountIndex);
        return homeRepo.validateNotification(meta, params!.receiverId, params.answer);
  });
}

class ValidateNotificationRequestUseCaseParams {
  final String receiverId;
  final bool answer;

  ValidateNotificationRequestUseCaseParams(this.receiverId, this.answer);
}