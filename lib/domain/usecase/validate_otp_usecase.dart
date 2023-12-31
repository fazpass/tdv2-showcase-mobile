import 'package:tdv2_showcase_mobile/domain/repo/login_repository.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';

class ValidateOtpUseCase extends OneTimeUseCase<bool, ValidateOtpUseCaseParam> {
  ValidateOtpUseCase(LoginRepository repo)
      : super((params) async {
        if (await repo.validateOtp(params!.phoneNumber, params.meta, params.otpId, params.otp)) {
          return repo.enroll(params.phoneNumber, params.meta);
        }

        return false;
      });
}

class ValidateOtpUseCaseParam {
  ValidateOtpUseCaseParam(this.phoneNumber, this.meta, this.otpId, this.otp);

  final String phoneNumber;
  final String meta;
  final String otpId;
  final String otp;
}