import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';
import 'package:tdv2_showcase_mobile/app/page/login/login_presenter.dart';
import 'package:tdv2_showcase_mobile/app/router.dart';
import 'package:tdv2_showcase_mobile/app/sheet/verify_login/verify_login_view.dart';
import 'package:tdv2_showcase_mobile/domain/entity/notifiable_device.dart';

class LoginController extends Controller {

  bool isLoading = false;
  String? _tempPhoneNumber;
  
  final LoginPresenter _presenter;
  LoginController(loginRepo, fazpassRepo, storedDataRepo)
      : _presenter = LoginPresenter(loginRepo, fazpassRepo, storedDataRepo);

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
      _presenter.initialize(
        'tdv2_showcase_public.pub',
        'tdv2_showcase_public.pub',
        '1:762638394860:ios:19b19305e8ae6a4dc90cc9'
      );
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

  _loginOnNext(bool canLoginInstantly, String meta, List<NotifiableDevice> notifiableDevices, String challenge) {
    isLoading = false;
    refreshUI();

    if (canLoginInstantly) {
      _navigateToHome();
    } else {
      _showVerifyLoginSheet(meta, notifiableDevices, challenge);
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
              'biometric or device passcode '
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
      print(e);
      showDialog(
        context: getContext(),
        builder: (c) => const AlertDialog(
          title: Text('Server Error'),
          content: Text('There seems to be a problem in the server, please try again later.'),
        ),
      );
    }

    throw e;
  }

  void _showVerifyLoginSheet(String meta, List<NotifiableDevice> notifiableDevices, String challenge) async {
    final phoneNumber = '$_tempPhoneNumber';
    final isSuccess = await showModalBottomSheet<bool>(
      context: getContext(),
      showDragHandle: true,
      builder: (c) => VerifyLoginSheet(
        meta: meta,
        phoneNumber: phoneNumber,
        notifiableDevices: notifiableDevices,
        challenge: challenge,
      ),
    );

    _tempPhoneNumber = null;
    if (isSuccess == true) {
      _navigateToHome();
    } else if (isSuccess == false) {
      showDialog(
        context: getContext(),
        builder: (c) => const AlertDialog(
          title: Text('Verify Login Failed'),
          content: Text('Failed to verify your identity. Please try again.'),
        ),
      );
    }
  }

  void _navigateToHome() {
    Navigator.popAndPushNamed(getContext(), AppPageRouter.home);
  }
}