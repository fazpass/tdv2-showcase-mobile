
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/repo/login_repository.dart';

class RequestOtpUseCase extends OneTimeUseCase<String, RequestOtpUseCaseParams> {
  RequestOtpUseCase(LoginRepository repo)
      : super((params) async {
        final otpId = await repo.requestOtp(params!.phoneNumber);
        return otpId;
      });
}

class RequestOtpUseCaseParams {
  final String phoneNumber;
  final String meta;

  RequestOtpUseCaseParams(this.phoneNumber, this.meta);
}