
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_observer.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/fazpass_generate_meta_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/fazpass_initialize_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/is_logged_in_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/login_usecase.dart';

class LoginPresenter extends Presenter {

  late Function(bool) initializeOnNext;
  late Function(dynamic) initializeOnError;
  late Function(String, String) loginOnNext;
  late Function(dynamic) loginOnError;

  final LoginUseCase _loginUseCase;
  final IsLoggedInUseCase _isLoggedInUseCase;
  final FazpassInitializeUseCase _initializeUseCase;
  final FazpassGenerateMetaUseCase _generateMetaUseCase;
  LoginPresenter(loginRepo, fazpassRepo)
      : _loginUseCase = LoginUseCase(loginRepo),
        _isLoggedInUseCase = IsLoggedInUseCase(loginRepo),
        _initializeUseCase = FazpassInitializeUseCase(fazpassRepo),
        _generateMetaUseCase = FazpassGenerateMetaUseCase(fazpassRepo);

  @override
  void dispose() {
    _loginUseCase.dispose();
    _isLoggedInUseCase.dispose();
    _initializeUseCase.dispose();
    _generateMetaUseCase.dispose();
  }

  String phoneNumber = '';

  void initialize() {
    _initializeUseCase.execute(_InitializeObserver(this), []);
  }

  void _initializeCallback(void _) {
    _isLoggedInUseCase.execute(OneTimeObserver(initializeOnNext, initializeOnError));
  }

  void login(String phoneNumber) {
    this.phoneNumber = phoneNumber;

    _generateMetaUseCase.execute(OneTimeObserver(_genMetaCallback, loginOnError));
  }

  void _genMetaCallback(String meta) {
    _loginUseCase.execute(
        OneTimeObserver((otpId) => loginOnNext(otpId, meta), loginOnError),
        LoginUseCaseParam(phoneNumber, meta));
  }
}

class _InitializeObserver implements Observer {

  final LoginPresenter presenter;
  _InitializeObserver(this.presenter);
  
  @override
  void onComplete() {
    presenter._initializeCallback(null);
  }

  @override
  void onError(e) {
    presenter.initializeOnError(e);
  }

  @override
  void onNext(_) {}
  
}