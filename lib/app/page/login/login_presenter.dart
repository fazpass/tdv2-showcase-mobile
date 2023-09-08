
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_observer.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/initialize_app_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/login_usecase.dart';

class LoginPresenter extends Presenter {

  late Function(bool) initializeOnNext;
  late Function(dynamic) initializeOnError;
  late Function(bool, String?, String?) loginOnNext;
  late Function(dynamic) loginOnError;

  final LoginUseCase _loginUseCase;
  final InitializeAppUseCase _initializeUseCase;
  LoginPresenter(loginRepo, fazpassRepo)
      : _loginUseCase = LoginUseCase(loginRepo, fazpassRepo),
        _initializeUseCase = InitializeAppUseCase(loginRepo, fazpassRepo);

  @override
  void dispose() {
    _loginUseCase.dispose();
    _initializeUseCase.dispose();
  }

  void initialize(String fazpassAssetName, List<SensitiveData> fazpassEnabledSensitiveData) {
    _initializeUseCase.execute(
      OneTimeObserver(initializeOnNext, initializeOnError),
      InitializeAppUseCaseParams(fazpassAssetName, fazpassEnabledSensitiveData),
    );
  }

  void login(String phoneNumber) {
    _loginUseCase.execute(
      OneTimeObserver((loginResponse) => loginOnNext(loginResponse.canLoginInstantly, loginResponse.otpId, loginResponse.meta), loginOnError),
      phoneNumber,
    );
  }
}