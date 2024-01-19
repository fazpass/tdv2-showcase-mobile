
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_observer.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/request_otp_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/send_notification_request_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/validate_otp_usecase.dart';

class VerifyLoginPresenter extends Presenter {

  late Function(String) requestOtpOnNext;
  late Function(dynamic) requestOtpOnError;
  late Function(bool) validateOtpOnNext;
  late Function(dynamic) validateOtpOnError;
  late Function(bool) sendNotificationForLoginVerificationOnNext;
  late Function(dynamic) sendNotificationForLoginVerificationOnError;

  final RequestOtpUseCase _requestOtpUseCase;
  final ValidateOtpUseCase _validateOtpUseCase;
  final SendNotificationRequestUseCase _sendNotificationForLoginVerificationUseCase;
  VerifyLoginPresenter(loginRepo, storedDataRepo)
      : _requestOtpUseCase = RequestOtpUseCase(loginRepo),
        _validateOtpUseCase = ValidateOtpUseCase(loginRepo, storedDataRepo),
        _sendNotificationForLoginVerificationUseCase = SendNotificationRequestUseCase(loginRepo);

  @override
  void dispose() {
    _requestOtpUseCase.dispose();
    _validateOtpUseCase.dispose();
    _sendNotificationForLoginVerificationUseCase.dispose();
  }

  void requestOtp(String phoneNumber, String meta) {
    _requestOtpUseCase.execute(
      OneTimeObserver(requestOtpOnNext, requestOtpOnError),
      RequestOtpUseCaseParams(phoneNumber, meta));
  }

  void validateOtp(String phoneNumber, String meta, String otpId, String otp, String challenge) {
    _validateOtpUseCase.execute(
        OneTimeObserver(validateOtpOnNext, validateOtpOnError),
        ValidateOtpUseCaseParam(phoneNumber, meta, otpId, otp, challenge));
  }

  void sendNotificationForLoginVerification(String phoneNumber, String meta, String selectedDevice) {
    _sendNotificationForLoginVerificationUseCase.execute(
      OneTimeObserver(sendNotificationForLoginVerificationOnNext, sendNotificationForLoginVerificationOnError),
      SendNotificationRequestUseCaseParams(phoneNumber, meta, selectedDevice));
  }
}