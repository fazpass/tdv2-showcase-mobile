import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import 'verify_login_presenter.dart';

enum VerifyLoginState {
  pickVerificationMethod,
  inputOtp, otpLoading, otpFailed,
  notificationSent, notificationFailedToSend
}

class VerifyLoginController extends Controller {

  VerifyLoginState state = VerifyLoginState.pickVerificationMethod;
  String? otpId;
  String? selectedDevice;
  
  final VerifyLoginPresenter presenter;
  VerifyLoginController(loginRepo)
      : presenter = VerifyLoginPresenter(loginRepo);

  void requestOtp(String phoneNumber, String meta) {
    state = VerifyLoginState.inputOtp;
    refreshUI();

    presenter.requestOtp(phoneNumber, meta);
  }

  void validateOtp(String otp, String phoneNumber, String meta) {
    if (otpId == null) return;

    state = VerifyLoginState.otpLoading;
    refreshUI();

    presenter.validateOtp(phoneNumber, meta, otpId!, otp);
  }

  void sendNotification(String phoneNumber, String meta, String selectedDeviceId, String selectedDeviceReadable) {
    selectedDevice = selectedDeviceReadable;

    state = VerifyLoginState.notificationSent;
    refreshUI();

    presenter.sendNotificationForLoginVerification(phoneNumber, meta, selectedDeviceId);
  }

  @override
  void initListeners() {
    presenter.requestOtpOnNext = _requestOtpOnNext;
    presenter.requestOtpOnError = _requestOtpOnError;
    presenter.validateOtpOnNext = _validateOtpOnNext;
    presenter.validateOtpOnError = _validateOtpOnError;
    presenter.sendNotificationForLoginVerificationOnNext = _sendNotificationForLoginVerificationOnNext;
    presenter.sendNotificationForLoginVerificationOnError = _sendNotificationForLoginVerificationOnError;
  }

  _requestOtpOnNext(String otpId) {
    this.otpId = otpId;
  }

  _requestOtpOnError(e) {
    logger.severe(e);
    state = VerifyLoginState.otpFailed;
    refreshUI();
  }

  _validateOtpOnNext(bool isSuccess) {
    popWithResult(isSuccess);
  }

  _validateOtpOnError(e) {
    logger.severe(e);
    state = VerifyLoginState.otpFailed;
    refreshUI();
  }

  _sendNotificationForLoginVerificationOnNext(bool isSuccess) {
    if (isSuccess) {
      state = VerifyLoginState.notificationSent;
    } else {
      state = VerifyLoginState.notificationFailedToSend;
    }
    refreshUI();
  }

  _sendNotificationForLoginVerificationOnError(e) {
    print(e);
    state = VerifyLoginState.notificationFailedToSend;
    refreshUI();
  }

  popWithResult(bool? isSuccess) {
    Navigator.pop(getContext(), isSuccess);
  }
}