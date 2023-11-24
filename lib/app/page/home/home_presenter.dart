
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:tdv2_showcase_mobile/domain/entity/category.dart';
import 'package:tdv2_showcase_mobile/domain/entity/product.dart';
import 'package:tdv2_showcase_mobile/domain/entity/promo.dart';
import 'package:tdv2_showcase_mobile/domain/entity/tenant.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_observer.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/get_categories_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/get_products_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/get_promos_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/get_tenants_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/listen_to_notification_request_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/logout_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/remove_device_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/validate_notification_request_usecase.dart';

class HomePresenter extends Presenter {

  late Function(List<Promo>) getPromosOnNext;
  late Function(dynamic) getPromosOnError;
  late Function(List<Product>) getProductsOnNext;
  late Function(dynamic) getProductsOnError;
  late Function(List<Category>) getCategoriesOnNext;
  late Function(dynamic) getCategoriesOnError;
  late Function(List<Tenant>) getTenantsOnNext;
  late Function(dynamic) getTenantsOnError;
  late Function(bool) removeDeviceOnNext;
  late Function(dynamic) removeDeviceOnError;
  late Function(bool) logoutOnNext;
  late Function(dynamic) logoutOnError;
  late Function(String, String) listenToNotificationRequestOnNext;
  late Function(dynamic) listenToNotificationRequestOnError;
  late Function(bool) validateNotificationOnNext;
  late Function(dynamic) validateNotificationOnError;

  final GetPromosUseCase _getPromosUseCase;
  final GetProductsUseCase _getProductsUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetTenantsUseCase _getTenantsUseCase;
  final RemoveDeviceUseCase _removeDeviceUseCase;
  final LogoutUseCase _logoutUseCase;
  final ListenToNotificationRequestUseCase _listenToNotificationRequestUseCase;
  final ValidateNotificationRequestUseCase _validateNotificationUseCase;
  HomePresenter(homeRepo, fazpassRepo)
      : _getPromosUseCase = GetPromosUseCase(homeRepo),
        _getProductsUseCase = GetProductsUseCase(homeRepo),
        _getCategoriesUseCase = GetCategoriesUseCase(homeRepo),
        _getTenantsUseCase = GetTenantsUseCase(homeRepo),
        _removeDeviceUseCase = RemoveDeviceUseCase(homeRepo, fazpassRepo),
        _logoutUseCase = LogoutUseCase(homeRepo),
        _listenToNotificationRequestUseCase = ListenToNotificationRequestUseCase(fazpassRepo),
        _validateNotificationUseCase = ValidateNotificationRequestUseCase(homeRepo, fazpassRepo);

  @override
  void dispose() {
    _getPromosUseCase.dispose();
    _getProductsUseCase.dispose();
    _getCategoriesUseCase.dispose();
    _getTenantsUseCase.dispose();
    _removeDeviceUseCase.dispose();
    _logoutUseCase.dispose();
    _listenToNotificationRequestUseCase.dispose();
    _validateNotificationUseCase.dispose();
  }

  void load() {
    _getPromosUseCase.execute(OneTimeObserver(getPromosOnNext, getPromosOnError));
    _getProductsUseCase.execute(OneTimeObserver(getProductsOnNext, getProductsOnError));
    _getCategoriesUseCase.execute(OneTimeObserver(getCategoriesOnNext, getCategoriesOnError));
    _getTenantsUseCase.execute(OneTimeObserver(getTenantsOnNext, getTenantsOnError));
    _listenToNotificationRequestUseCase.execute(OneTimeObserver(
      (cdRequest) => listenToNotificationRequestOnNext(cdRequest.deviceRequest, cdRequest.deviceIdReceive),
      listenToNotificationRequestOnError,
    ));
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
}