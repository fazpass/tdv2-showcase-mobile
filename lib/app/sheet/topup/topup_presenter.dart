
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_observer.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/get_payment_url_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/validate_usecase.dart';

class TopupPresenter extends Presenter {

  late Function(int, String) validateOnNext;
  late Function(dynamic) validateOnError;
  late Function(String) getPaymentUrlOnNext;
  late Function(dynamic) getPaymentUrlOnError;

  final ValidateUseCase _validateUseCase;
  final GetPaymentUrlUseCase _getPaymentUrlUseCase;
  TopupPresenter(homeRepo, fazpassRepo)
      : _validateUseCase = ValidateUseCase(homeRepo, fazpassRepo),
        _getPaymentUrlUseCase = GetPaymentUrlUseCase(homeRepo);

  @override
  void dispose() {
    _validateUseCase.dispose();
    _getPaymentUrlUseCase.dispose();
  }

  void validate() async {
    _validateUseCase.execute(
        OneTimeObserver((validateResponse) => validateOnNext(validateResponse.score, validateResponse.riskDescription), validateOnError)
    );
  }

  void getPaymentUrl(int topupAmount) {
    _getPaymentUrlUseCase.execute(
        OneTimeObserver(getPaymentUrlOnNext, getPaymentUrlOnError), topupAmount
    );
  }
}