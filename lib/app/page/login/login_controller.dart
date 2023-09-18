import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';
import 'package:tdv2_showcase_mobile/app/page/login/login_presenter.dart';
import 'package:tdv2_showcase_mobile/app/router.dart';
import 'package:tdv2_showcase_mobile/app/sheet/validate_otp/validate_otp_view.dart';

class LoginController extends Controller {

  bool isLoading = false;
  String? _tempPhoneNumber;
  
  final LoginPresenter _presenter;
  LoginController(loginRepo, fazpassRepo)
      : _presenter = LoginPresenter(loginRepo, fazpassRepo);

  void login(String phoneNumber) {
    isLoading = true;
    _tempPhoneNumber = phoneNumber;
    refreshUI();

    if (_tempPhoneNumber!.startsWith('+')) {
      _tempPhoneNumber = _tempPhoneNumber!.substring(1);
    }
    if (_tempPhoneNumber!.startsWith('62')) {
      _tempPhoneNumber = '0${_tempPhoneNumber!.substring(2)}';
    }

    _presenter.login(_tempPhoneNumber!);
  }

  @override
  void onInitState() {
    super.onInitState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      _presenter.initialize('tdv2_showcase_public.pub', []);
    });
  }

  @override
  void initListeners() {
    _presenter.initializeOnNext = _initializeOnNext;
    _presenter.initializeOnError = _initializeOnError;
    _presenter.loginOnNext = _loginOnNext;
    _presenter.loginOnError = _loginOnError;
  }

  _initializeOnNext(bool isLoggedIn) {
    if (isLoggedIn) _navigateToHome();
  }

  _initializeOnError(e) {
    throw e;
  }

  _loginOnNext(bool canLoginInstantly, String? otpId, String? meta) {
    isLoading = false;
    refreshUI();

    if (canLoginInstantly) {
      _navigateToHome();
    } else {
      _showOtpValidationSheet(otpId!, meta!);
    }
  }

  _loginOnError(e) {
    isLoading = false;
    _tempPhoneNumber = null;
    refreshUI();

    if (e is FazpassException) {
      String message;
      switch (e) {
        case BiometricNoneEnrolledError():
          message = 'You have to enroll '
              'biometric (e.g. Fingerprint, Face, Iris) '
              'or device credential (e.g. Pattern, PIN, Password) '
              'on your phone to continue.';
          break;
        case BiometricUnavailableError():
          message = 'Biometric hardware is currently unavailable.';
          break;
        default:
          message = e.message ?? e.toString();
          break;
      }
      
      showDialog(
        context: getContext(),
        builder: (c) => AlertDialog(
          title: const Text('Error'),
          content: Text(message),
        ),
      );
    } else if (e is TimeoutException) {
      showDialog(
        context: getContext(),
        builder: (c) => const AlertDialog(
          title: Text('Connection Timeout'),
          content: Text('Please check your internet and try again.'),
        ),
      );
    } else {
      throw e;
    }
  }

  void _showOtpValidationSheet(String otpId, String meta) async {
    final phoneNumber = '$_tempPhoneNumber';
    final isSuccess = await showModalBottomSheet<bool>(
      context: getContext(),
      showDragHandle: true,
      builder: (c) => ValidateOtpSheet(otpId: otpId, meta: meta, phoneNumber: phoneNumber),
    );

    _tempPhoneNumber = null;
    if (isSuccess ?? false) {
      _navigateToHome();
    } else {
      showDialog(
        context: getContext(),
        builder: (c) => const AlertDialog(
          title: Text('Incorrect OTP'),
          content: Text('OTP validation failed. Please try again.'),
        ),
      );
    }
  }

  void _navigateToHome() {
    Navigator.popAndPushNamed(getContext(), AppPageRouter.home);
  }
}