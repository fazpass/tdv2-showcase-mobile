
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';
import 'package:tdv2_showcase_mobile/domain/helper/nullable_one_time_observer.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_observer.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/get_fazpass_settings_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/listen_to_notification_request_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/logout_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/remove_device_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/set_fazpass_settings_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/validate_notification_request_usecase.dart';

class HomePresenter extends Presenter {

  late Function(bool) removeDeviceOnNext;
  late Function(dynamic) removeDeviceOnError;
  late Function(bool) logoutOnNext;
  late Function(dynamic) logoutOnError;
  late Function(String, String) listenToNotificationRequestOnNext;
  late Function(dynamic) listenToNotificationRequestOnError;
  late Function(bool) validateNotificationOnNext;
  late Function(dynamic) validateNotificationOnError;
  late Function(FazpassSettings?) getFazpassSettingsOnNext;
  late Function(dynamic) getFazpassSettingsOnError;
  late Function(bool) setFazpassSettingsOnNext;
  late Function(dynamic) setFazpassSettingsOnError;

  final RemoveDeviceUseCase _removeDeviceUseCase;
  final LogoutUseCase _logoutUseCase;
  final ListenToNotificationRequestUseCase _listenToNotificationRequestUseCase;
  final ValidateNotificationRequestUseCase _validateNotificationUseCase;
  final GetFazpassSettingsUseCase _getFazpassSettingsUseCase;
  final SetFazpassSettingsUseCase _setFazpassSettingsUseCase;
  HomePresenter(homeRepo, fazpassRepo, storedDataRepo)
      : _removeDeviceUseCase = RemoveDeviceUseCase(homeRepo, fazpassRepo, storedDataRepo),
        _logoutUseCase = LogoutUseCase(storedDataRepo, fazpassRepo),
        _listenToNotificationRequestUseCase = ListenToNotificationRequestUseCase(fazpassRepo),
        _validateNotificationUseCase = ValidateNotificationRequestUseCase(homeRepo, fazpassRepo, storedDataRepo),
        _getFazpassSettingsUseCase = GetFazpassSettingsUseCase(fazpassRepo, storedDataRepo),
        _setFazpassSettingsUseCase = SetFazpassSettingsUseCase(fazpassRepo, storedDataRepo);

  @override
  void dispose() {
    _removeDeviceUseCase.dispose();
    _logoutUseCase.dispose();
    _listenToNotificationRequestUseCase.dispose();
    _validateNotificationUseCase.dispose();
    _getFazpassSettingsUseCase.dispose();
    _setFazpassSettingsUseCase.dispose();
  }

  void load() {
    _listenToNotificationRequestUseCase.execute(
        OneTimeObserver(
            (cdRequest) => listenToNotificationRequestOnNext(cdRequest.deviceRequest, cdRequest.deviceIdReceive),
            listenToNotificationRequestOnError));
    _getFazpassSettingsUseCase.execute(NullableOneTimeObserver(getFazpassSettingsOnNext, getFazpassSettingsOnError));
  }

  void validateNotification(String receiverId, bool answer) {
    _validateNotificationUseCase.execute(
        OneTimeObserver(validateNotificationOnNext, validateNotificationOnError),
        ValidateNotificationRequestUseCaseParams(receiverId, answer));
  }

  void logout() {
    _logoutUseCase.execute(OneTimeObserver(logoutOnNext, logoutOnError));
  }

  void removeDevice() {
    _removeDeviceUseCase.execute(
        OneTimeObserver(removeDeviceOnNext, removeDeviceOnError)
    );
  }

  void setFazpassSettings(FazpassSettings? settings) {
    _setFazpassSettingsUseCase.execute(
      OneTimeObserver(setFazpassSettingsOnNext, setFazpassSettingsOnError),
      settings);
  }
}