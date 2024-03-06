
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_trusted_device_v2/flutter_trusted_device_v2.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tdv2_showcase_mobile/app/router.dart';
import 'package:tdv2_showcase_mobile/app/sheet/topup/topup_view.dart';
import 'package:tdv2_showcase_mobile/app/widget/settings_dialog.dart';

import 'home_presenter.dart';

class HomeController extends Controller {

  int pageIndex = 0;

  int balanceAmount = 0;
  int pickedAmount = 0;
  FazpassSettings? fazpassSettings;
  FazpassSettings? tempFazpassSettings;

  final HomePresenter _presenter;
  HomeController(homeRepo, fazpassRepo, storedDataRepo)
      : _presenter = HomePresenter(homeRepo, fazpassRepo, storedDataRepo);

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
      builder: (c) => const TopupSheet(),
    );

    if (paymentConfirmed ?? false) {
      balanceAmount += pickedAmount;
      refreshUI();
    }
  }

  void openSettings() async {
    final builder = fazpassSettings != null
        ? FazpassSettingsBuilder.fromFazpassSettings(fazpassSettings!)
        : FazpassSettingsBuilder();

    final settings = await showDialog<FazpassSettings>(
      context: getContext(),
      builder: (c) => SettingsDialog(builder: builder),
    );

    if (settings != null) {
      tempFazpassSettings = settings;
      _presenter.setFazpassSettings(settings);
    }
  }

  void removeDevice() async {
    final confirmation = await showDialog<bool>(
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

    if (confirmation ?? false) {
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
    _presenter.removeDeviceOnNext = _removeDeviceOnNext;
    _presenter.removeDeviceOnError = _removeDeviceOnError;
    _presenter.logoutOnNext = _logoutOnNext;
    _presenter.logoutOnError = _logoutOnError;
    _presenter.listenToNotificationRequestOnNext = _listenToNotificationRequestOnNext;
    _presenter.listenToNotificationRequestOnError = _listenToNotificationRequestOnError;
    _presenter.validateNotificationOnNext = _validateNotificationOnNext;
    _presenter.validateNotificationOnError = _validateNotificationOnError;
    _presenter.getFazpassSettingsOnNext = _getFazpassSettingsOnNext;
    _presenter.getFazpassSettingsOnError = _getFazpassSettingsOnError;
    _presenter.setFazpassSettingsOnNext = _setFazpassSettingsOnNext;
    _presenter.setFazpassSettingsOnError = _setFazpassSettingsOnError;
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
        content: Text('Device "${requesterDeviceInfo.split(';').getRange(0, 2).join(', ')}" wants to '
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

  _getFazpassSettingsOnNext(FazpassSettings? settings) {
    fazpassSettings = settings;
  }

  _getFazpassSettingsOnError(e) {
    print(e);
  }

  _setFazpassSettingsOnNext(bool p1) async {
    fazpassSettings = tempFazpassSettings;
    tempFazpassSettings = null;

    await showDialog(
      context: getContext(),
      builder: (c) => AlertDialog(
        title: const Text('Saved'),
        content: const Text('Settings successfully saved.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('OK')),
        ],
      ),
    );

    [
      if (fazpassSettings?.sensitiveData.contains(SensitiveData.location) ?? false) Permission.location,
      if (fazpassSettings?.sensitiveData.contains(SensitiveData.simNumbersAndOperators) ?? false) Permission.phone,
    ].request();
  }

  _setFazpassSettingsOnError(e) {
    tempFazpassSettings = null;

    print(e);
    showDialog(
      context: getContext(),
      builder: (c) => AlertDialog(
        title: const Text('Error'),
        content: const Text('Settings failed to save.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('OK')),
        ],
      ),
    );
  }
}