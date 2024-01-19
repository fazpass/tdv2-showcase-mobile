
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/repo/login_repository.dart';

class SendNotificationRequestUseCase extends OneTimeUseCase<bool, SendNotificationRequestUseCaseParams> {
  SendNotificationRequestUseCase(LoginRepository loginRepo)
      : super((params) => loginRepo.sendNotification(params!.phoneNumber, params.meta, params.selectedDevice));
}

class SendNotificationRequestUseCaseParams {
  final String phoneNumber;
  final String meta;
  final String selectedDevice;

  SendNotificationRequestUseCaseParams(
      this.phoneNumber, this.meta, this.selectedDevice);
}