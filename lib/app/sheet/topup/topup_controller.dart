import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import 'topup_presenter.dart';

enum TopupControlledState {
  validating, validateFailed, validateSuccessDeviceUntrusted,
  validateSuccessDeviceTrusted
}

class TopupController extends Controller {

  TopupControlledState state = TopupControlledState.validating;
  String url = '';

  double _confidenceValue = -1;

  final TopupPresenter _presenter;
  TopupController(homeRepo, fazpassRepo, storedDataRepo)
      : _presenter = TopupPresenter(homeRepo, fazpassRepo, storedDataRepo);

  /// Whether this device is currently trusted.
  bool isTrusted() => _confidenceValue > 100;

  void onConfirmPayment() {
    Navigator.pop(getContext(), true);
  }

  @override
  void onInitState() {
    super.onInitState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      _presenter.validate();
    });
  }

  @override
  void initListeners() {
    _presenter.validateOnNext = _validateOnNext;
    _presenter.validateOnError = _validateOnError;
  }

  _validateOnNext(double score, String riskDescription) {
    _confidenceValue = score;

    if (isTrusted()) {
      state = TopupControlledState.validateSuccessDeviceTrusted;
      refreshUI();
      return;
    }

    state = TopupControlledState.validateSuccessDeviceUntrusted;
    refreshUI();
  }

  _validateOnError(e) {
    logger.severe(e);
    state = TopupControlledState.validateFailed;
    refreshUI();
  }
}