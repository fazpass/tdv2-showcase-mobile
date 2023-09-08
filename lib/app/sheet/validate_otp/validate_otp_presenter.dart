
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_observer.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/validate_otp_then_enroll_usecase.dart';

class ValidateOtpPresenter extends Presenter {

  late Function(bool) validateOtpThenEnrollOnNext;
  late Function(dynamic) validateOtpThenEnrollOnError;

  final ValidateOtpThenEnrollUseCase _validateOtpThenEnrollUseCase;
  ValidateOtpPresenter(loginRepo)
      : _validateOtpThenEnrollUseCase = ValidateOtpThenEnrollUseCase(loginRepo);

  @override
  void dispose() {
    _validateOtpThenEnrollUseCase.dispose();
  }

  void validateOtpThenEnroll(String phoneNumber, String meta, String otpId, String otp) {
    _validateOtpThenEnrollUseCase.execute(
        OneTimeObserver(validateOtpThenEnrollOnNext, validateOtpThenEnrollOnError),
        ValidateOtpThenEnrollUseCaseParam(phoneNumber, meta, otpId, otp));
  }
}