
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:tdv2_showcase_mobile/domain/entity/category.dart';
import 'package:tdv2_showcase_mobile/domain/entity/product.dart';
import 'package:tdv2_showcase_mobile/domain/entity/promo.dart';
import 'package:tdv2_showcase_mobile/domain/entity/tenant.dart';
import 'package:tdv2_showcase_mobile/domain/helper/one_time_observer.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/get_categories.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/get_products.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/get_promos.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/get_tenants.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/logout_usecase.dart';
import 'package:tdv2_showcase_mobile/domain/usecase/remove_device_usecase.dart';

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

  final GetPromosUseCase _getPromosUseCase;
  final GetProductsUseCase _getProductsUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetTenantsUseCase _getTenantsUseCase;
  final RemoveDeviceUseCase _removeDeviceUseCase;
  final LogoutUseCase _logoutUseCase;
  HomePresenter(homeRepo, fazpassRepo)
      : _getPromosUseCase = GetPromosUseCase(homeRepo),
        _getProductsUseCase = GetProductsUseCase(homeRepo),
        _getCategoriesUseCase = GetCategoriesUseCase(homeRepo),
        _getTenantsUseCase = GetTenantsUseCase(homeRepo),
        _removeDeviceUseCase = RemoveDeviceUseCase(homeRepo, fazpassRepo),
        _logoutUseCase = LogoutUseCase(homeRepo);

  @override
  void dispose() {
    _getPromosUseCase.dispose();
    _getProductsUseCase.dispose();
    _getCategoriesUseCase.dispose();
    _getTenantsUseCase.dispose();
    _removeDeviceUseCase.dispose();
    _logoutUseCase.dispose();
  }

  void load() {
    _getPromosUseCase.execute(OneTimeObserver(getPromosOnNext, getPromosOnError));
    _getProductsUseCase.execute(OneTimeObserver(getProductsOnNext, getProductsOnError));
    _getCategoriesUseCase.execute(OneTimeObserver(getCategoriesOnNext, getCategoriesOnError));
    _getTenantsUseCase.execute(OneTimeObserver(getTenantsOnNext, getTenantsOnError));
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