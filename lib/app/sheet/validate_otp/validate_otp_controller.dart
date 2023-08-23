import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:tdv2_showcase_mobile/app/sheet/validate_otp/validate_otp_presenter.dart';

class ValidateOtpController extends Controller {

  bool isLoading = false;
  
  final ValidateOtpPresenter presenter;
  ValidateOtpController(loginRepo)
      : presenter = ValidateOtpPresenter(loginRepo);

  void otpValidation(String otpId, String otp, String phoneNumber, String meta) {
    isLoading = true;
    refreshUI();

    presenter.validateOtp(phoneNumber, meta, otpId, otp);
  }

  @override
  void initListeners() {
    presenter.validateOtpOnNext = _validateOtpOnNext;
    presenter.validateOtpOnError = _validateOtpOnError;
  }

  _validateOtpOnNext(bool isSuccess) {
    isLoading = false;
    refreshUI();

    Navigator.pop(getContext(), isSuccess);
  }

  _validateOtpOnError(e) {
    logger.severe(e);
    isLoading = false;
    refreshUI();
  }
}