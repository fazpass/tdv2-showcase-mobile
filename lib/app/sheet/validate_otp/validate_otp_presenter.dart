
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_observer.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/validate_otp_usecase.dart';

class ValidateOtpPresenter extends Presenter {

  late Function(bool) validateOtpOnNext;
  late Function(dynamic) validateOtpOnError;

  final ValidateOtpUseCase _validateOtpUseCase;
  ValidateOtpPresenter(loginRepo)
      : _validateOtpUseCase = ValidateOtpUseCase(loginRepo);

  @override
  void dispose() {
    _validateOtpUseCase.dispose();
  }

  void validateOtp(String phoneNumber, String meta, String otpId, String otp) {
    _validateOtpUseCase.execute(
        OneTimeObserver(validateOtpOnNext, validateOtpOnError),
        ValidateOtpUseCaseParam(phoneNumber, meta, otpId, otp));
  }
}