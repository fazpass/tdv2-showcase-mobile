
import 'package:tdv2_showcase_mobile/domain/repo/login_repository.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/repo/stored_data_repository.dart';

class ValidateOtpUseCase extends OneTimeUseCase<bool, ValidateOtpUseCaseParam> {
  ValidateOtpUseCase(LoginRepository loginRepo, StoredDataRepository storedDataRepo)
      : super((params) async {
        if (await loginRepo.validateOtp(params!.phoneNumber, params.meta, params.otpId, params.otp)) {
          final fazpassId = await loginRepo.enroll(params.phoneNumber, params.meta, params.challenge);
          if (fazpassId != null) return storedDataRepo.saveLoginDetail(params.phoneNumber, fazpassId);
        }

        return false;
      });
}

class ValidateOtpUseCaseParam {
  final String phoneNumber;
  final String meta;
  final String otpId;
  final String otp;
  final String challenge;

  ValidateOtpUseCaseParam(this.phoneNumber, this.meta, this.otpId, this.otp, this.challenge);
}