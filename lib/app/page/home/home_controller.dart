
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:tdv2_showcase_mobile/app/router.dart';
import 'package:tdv2_showcase_mobile/domain/entity/category.dart';
import 'package:tdv2_showcase_mobile/domain/entity/product.dart';
import 'package:tdv2_showcase_mobile/domain/entity/promo.dart';
import 'package:tdv2_showcase_mobile/domain/entity/tenant.dart';
import 'package:tdv2_showcase_mobile/app/sheet/topup/topup_view.dart';

import 'home_presenter.dart';

class HomeController extends Controller {

  int pageIndex = 0;

  int balanceAmount = 0;
  int pickedAmount = 0;

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

  void changePageIndex(int index) {
    pageIndex = index;
    refreshUI();
  }

  void changePickedAmount(int amount) {
    pickedAmount = amount;
    refreshUI();
  }

  void topup() async {
    final paymentConfirmed = await showModalBottomSheet<bool>(
      context: getContext(),
      enableDrag: false,
      isScrollControlled: true,
      constraints: const BoxConstraints(maxHeight: 600),
      builder: (c) => TopupSheet(topupAmount: pickedAmount),
    );

    if (paymentConfirmed ?? false) {
      balanceAmount += pickedAmount;
      refreshUI();
    }
  }

  void removeDevice() async {
    final confirmation = await showDialog(
      context: getContext(),
      builder: (c) => AlertDialog(
        title: const Text('Remove Device'),
        content: const Text('Are you sure you want to remove your device? After this, you will be logged out and have to input OTP again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('NO'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('YES'),
          ),
        ],
      ),
    );

    if (confirmation) {
      showDialog(
        context: getContext(),
        builder: (c) => const AlertDialog(
          title: Text('Removing device & Logging out...'),
          content: SizedBox(height: 70, child: Center(child: CircularProgressIndicator())),
        ),
      );

      _presenter.removeDevice();
    }
  }

  void logout() {
    _presenter.logout();
  }

  void respondToLoginRequest(BuildContext c, String receiverId, bool answer) {
    _presenter.validateNotification(receiverId, answer);
    Navigator.pop(c);
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
    _presenter.removeDeviceOnNext = _removeDeviceOnNext;
    _presenter.removeDeviceOnError = _removeDeviceOnError;
    _presenter.logoutOnNext = _logoutOnNext;
    _presenter.logoutOnError = _logoutOnError;
    _presenter.listenToNotificationRequestOnNext = _listenToNotificationRequestOnNext;
    _presenter.listenToNotificationRequestOnError = _listenToNotificationRequestOnError;
    _presenter.validateNotificationOnNext = _validateNotificationOnNext;
    _presenter.validateNotificationOnError = _validateNotificationOnError;
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

  _removeDeviceOnNext(bool isSuccess) {
    Navigator.pop(getContext());
    if (isSuccess) {
      Navigator.popAndPushNamed(getContext(), AppPageRouter.login);
    }
  }

  _removeDeviceOnError(e) {
    logger.severe(e);
    Navigator.pop(getContext());
  }

  _logoutOnNext(bool isSuccess) {
    if (isSuccess) {
      Navigator.popAndPushNamed(getContext(), AppPageRouter.login);
    }
  }

  _logoutOnError(e) {
    logger.severe(e);
  }

  _listenToNotificationRequestOnNext(String requesterDeviceInfo, String receiverId) {
    showDialog(
      context: getContext(),
      builder: (c) => AlertDialog(
        title: const Text('Verify Login'),
        content: Text('Device "${requesterDeviceInfo.split('/').getRange(0, 2).join(', ')}" wants to '
            'login with your account. Accept it?'),
        actions: [
          TextButton(onPressed: () => respondToLoginRequest(c, receiverId, true), child: const Text('Accept')),
          TextButton(onPressed: () => respondToLoginRequest(c, receiverId, false), child: const Text('Decline')),
        ],
      ),
    );
  }

  _listenToNotificationRequestOnError(e) {
    print(e);
  }

  _validateNotificationOnNext(bool isSuccess) {
    showDialog(
      context: getContext(),
      builder: (c) => AlertDialog(
        title: const Text('Verify Login Status'),
        content: Text('Verify login ${isSuccess ? 'responded successfully' : 'failed to respond'}.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('OK')),
        ],
      ),
    );
  }

  _validateNotificationOnError(e) {
    print(e);
    showDialog(
      context: getContext(),
      builder: (c) => AlertDialog(
        title: const Text('Verify Login Status'),
        content: const Text('Verify login failed to respond.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('OK')),
        ],
      ),
    );
  }
}