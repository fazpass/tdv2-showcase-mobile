import 'package:tdv2_showcase_mobile/domain/repo/login_repository.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';

class ValidateOtpThenEnrollUseCase extends OneTimeUseCase<bool, ValidateOtpThenEnrollUseCaseParam> {
  ValidateOtpThenEnrollUseCase(LoginRepository repo)
      : super((params) => repo.validateOtpThenEnroll(params!.phoneNumber, params.meta, params.otpId, params.otp));
}

class ValidateOtpThenEnrollUseCaseParam {
  ValidateOtpThenEnrollUseCaseParam(this.phoneNumber, this.meta, this.otpId, this.otp);

  final String phoneNumber;
  final String meta;
  final String otpId;
  final String otp;
}