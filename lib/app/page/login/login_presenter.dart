
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:tdv2_showcase_mobile/domain/entity/notifiable_device.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_observer.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/initialize_app_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/login_usecase.dart';

class LoginPresenter extends Presenter {

  late Function(bool) initializeOnNext;
  late Function(dynamic) initializeOnError;
  late Function(bool, String, List<NotifiableDevice>, String) loginOnNext;
  late Function(dynamic) loginOnError;

  final LoginUseCase _loginUseCase;
  final InitializeAppUseCase _initializeUseCase;
  LoginPresenter(loginRepo, fazpassRepo, storedDataRepo)
      : _loginUseCase = LoginUseCase(loginRepo, fazpassRepo, storedDataRepo),
        _initializeUseCase = InitializeAppUseCase(loginRepo, fazpassRepo);

  @override
  void dispose() {
    _loginUseCase.dispose();
    _initializeUseCase.dispose();
  }

  void initialize() {
    _initializeUseCase.execute(OneTimeObserver(initializeOnNext, initializeOnError));
  }

  void login(String phoneNumber) {
    _loginUseCase.execute(
      OneTimeObserver((r) => loginOnNext(r.canLoginInstantly, r.meta, r.notifiableDevices, r.challenge), loginOnError),
      phoneNumber,
    );
  }
}