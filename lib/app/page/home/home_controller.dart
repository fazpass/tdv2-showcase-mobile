
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:tdv2_showcase_mobile/app/router.dart';
import 'package:tdv2_showcase_mobile/app/sheet/validate/validate_view.dart';
import 'package:tdv2_showcase_mobile/domain/entity/category.dart';
import 'package:tdv2_showcase_mobile/domain/entity/product.dart';
import 'package:tdv2_showcase_mobile/domain/entity/promo.dart';
import 'package:tdv2_showcase_mobile/domain/entity/tenant.dart';

import 'home_presenter.dart';

class HomeController extends Controller {

  bool isLoadingPromos = true;
  List<Promo> promos = [];
  bool isLoadingProducts = true;
  List<Product> products = [];
  bool isLoadingCategories = true;
  List<Category> categories = [];
  bool isLoadingTenants = true;
  List<Tenant> tenants = [];

  final HomePresenter _presenter;
  HomeController(homeRepo, fazpassRepo)
      : _presenter = HomePresenter(homeRepo, fazpassRepo);

  void validate() {
    showModalBottomSheet(
      context: getContext(),
      showDragHandle: true,
      builder: (c) => const ValidateSheet(),
    );
  }

  void logout() {
    showDialog(
      context: getContext(),
      builder: (c) => const AlertDialog(
        title: Text('Logging out...'),
        content: SizedBox(height: 70, child: Center(child: CircularProgressIndicator())),
      ),
    );

    _presenter.logout();
  }

  @override
  void onInitState() {
    super.onInitState();
    _presenter.load();
  }

  @override
  void initListeners() {
    _presenter.getPromosOnNext = _getPromosOnNext;
    _presenter.getPromosOnError = _getPromosOnError;
    _presenter.getProductsOnNext = _getProductsOnNext;
    _presenter.getProductsOnError = _getProductsOnError;
    _presenter.getCategoriesOnNext = _getCategoriesOnNext;
    _presenter.getCategoriesOnError = _getCategoriesOnError;
    _presenter.getTenantsOnNext = _getTenantsOnNext;
    _presenter.getTenantsOnError = _getTenantsOnError;
    _presenter.logoutOnNext = _logoutOnNext;
    _presenter.logoutOnError = _logoutOnError;
  }

  _getPromosOnNext(List<Promo> p1) {
    isLoadingPromos = false;
    promos = p1;
    refreshUI();
  }

  _getPromosOnError(e) {
    logger.severe(e);
    isLoadingPromos = false;
    refreshUI();
  }

  _getProductsOnNext(List<Product> p1) {
    isLoadingProducts = false;
    products = p1;
    refreshUI();
  }

  _getProductsOnError(e) {
    logger.severe(e);
    isLoadingProducts = false;
    refreshUI();
  }

  _getCategoriesOnNext(List<Category> p1) {
    isLoadingCategories = false;
    categories = p1;
    refreshUI();
  }

  _getCategoriesOnError(e) {
    logger.severe(e);
    isLoadingCategories = false;
    refreshUI();
  }

  _getTenantsOnNext(List<Tenant> p1) {
    isLoadingTenants = false;
    tenants = p1;
    refreshUI();
  }

  _getTenantsOnError(e) {
    logger.severe(e);
    isLoadingTenants = false;
    refreshUI();
  }

  _logoutOnNext(bool isSuccess) {
    Navigator.pop(getContext());
    if (isSuccess) {
      Navigator.popAndPushNamed(getContext(), AppPageRouter.login);
    }
  }

  _logoutOnError(e) {
    logger.severe(e);
    Navigator.pop(getContext());
  }
}