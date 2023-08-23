
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:tdv2_showcase_mobile/domain/entity/validate_result.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_observer.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/fazpass_generate_meta_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/validate_usecase.dart';

class ValidatePresenter extends Presenter {

  late Function(ValidateResult) validateOnNext;
  late Function(dynamic) validateOnError;

  final ValidateUseCase _validateUseCase;
  final FazpassGenerateMetaUseCase _generateMetaUseCase;
  ValidatePresenter(homeRepo, fazpassRepo)
      : _validateUseCase = ValidateUseCase(homeRepo),
        _generateMetaUseCase = FazpassGenerateMetaUseCase(fazpassRepo);

  @override
  void dispose() {
    _validateUseCase.dispose();
    _generateMetaUseCase.dispose();
  }

  void validate() async {
    genMetaCallback(String meta) {
      _validateUseCase.execute(
          OneTimeObserver(validateOnNext, validateOnError), meta
      );
    }

    _generateMetaUseCase.execute(
        OneTimeObserver(genMetaCallback, validateOnError)
    );
  }
}