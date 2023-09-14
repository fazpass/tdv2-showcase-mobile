
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_observer.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/verify_login_usecase.dart';

class ValidateOtpPresenter extends Presenter {

  late Function(bool) verifyLoginOnNext;
  late Function(dynamic) verifyLoginOnError;

  final VerifyLoginUseCase _verifyLoginUseCase;
  ValidateOtpPresenter(loginRepo)
      : _verifyLoginUseCase = VerifyLoginUseCase(loginRepo);

  @override
  void dispose() {
    _verifyLoginUseCase.dispose();
  }

  void verifyLogin(String phoneNumber, String meta, String otpId, String otp) {
    _verifyLoginUseCase.execute(
        OneTimeObserver(verifyLoginOnNext, verifyLoginOnError),
        VerifyLoginUseCaseParam(phoneNumber, meta, otpId, otp));
  }
}