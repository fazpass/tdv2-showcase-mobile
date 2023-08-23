import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
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

    _presenter.login(phoneNumber);
  }

  @override
  void onInitState() {
    super.onInitState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      _presenter.initialize();
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

  _initializeOnError(e) {}

  _loginOnNext(String otpId, String meta) {
    isLoading = false;
    refreshUI();

    _showOtpValidationSheet(otpId, meta);
  }

  _loginOnError(e) {
    logger.severe(e);
    print(e);
    isLoading = false;
    _tempPhoneNumber = null;
    refreshUI();
  }

  void _showOtpValidationSheet(String otpId, String meta) async {
    final isSuccess = await showModalBottomSheet<bool>(
      context: getContext(),
      showDragHandle: true,
      builder: (c) => ValidateOtpSheet(otpId: otpId, meta: meta, phoneNumber: _tempPhoneNumber!),
    );

    _tempPhoneNumber = null;
    if (isSuccess ?? false) {
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    Navigator.popAndPushNamed(getContext(), AppPageRouter.home);
  }
}