import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:tdv2_showcase_mobile/domain/entity/validate_result.dart';

import 'validate_presenter.dart';

class ValidateController extends Controller {

  bool hasValidate = false;
  String message = 'Validating...';
  int? confidenceValue;
  String? confidenceLevel;
  
  final ValidatePresenter _presenter;
  ValidateController(homeRepo, fazpassRepo)
      : _presenter = ValidatePresenter(homeRepo, fazpassRepo);

  void validate() {
    hasValidate = true;
    _presenter.validate();
  }

  @override
  void initListeners() {
    _presenter.validateOnNext = _validateOnNext;
    _presenter.validateOnError = _validateOnError;
  }

  _validateOnNext(ValidateResult value) {
    message = 'Confidence score:';
    confidenceValue = value.score;
    confidenceLevel = value.riskDescription;
    refreshUI();
  }

  _validateOnError(e) {
    logger.severe(e);
    message = 'Failed to calculate confidence value.';
    confidenceValue = -1;
    refreshUI();
  }
}