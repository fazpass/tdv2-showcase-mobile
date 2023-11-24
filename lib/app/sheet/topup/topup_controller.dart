import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import 'topup_presenter.dart';

class TopupController extends Controller {

  int? topupAmount;
  int? confidenceValue;
  String? riskLevel;
  String? url;
  
  final TopupPresenter _presenter;
  TopupController(homeRepo, fazpassRepo)
      : _presenter = TopupPresenter(homeRepo, fazpassRepo);

  void validate() {
    _presenter.validate();
  }

  void onConfirmPayment() {
    Navigator.pop(getContext(), true);
  }

  @override
  void onInitState() {
    super.onInitState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      validate();
    });
  }

  @override
  void initListeners() {
    _presenter.validateOnNext = _validateOnNext;
    _presenter.validateOnError = _validateOnError;
    _presenter.getPaymentUrlOnNext = _getPaymentUrlOnNext;
    _presenter.getPaymentUrlOnError = _getPaymentUrlError;
  }

  _validateOnNext(int score, String riskDescription) {
    confidenceValue = score;
    riskLevel = riskDescription;
    refreshUI();

    if (riskLevel!.toLowerCase() == 'low') _presenter.getPaymentUrl(topupAmount!);
  }

  _validateOnError(e) {
    logger.severe(e);
    confidenceValue = -1;
    refreshUI();
  }

  _getPaymentUrlOnNext(String url) {
    this.url = url;
    refreshUI();
  }

  _getPaymentUrlError(e) {
    logger.severe(e);
    url = '';
    refreshUI();
  }
}