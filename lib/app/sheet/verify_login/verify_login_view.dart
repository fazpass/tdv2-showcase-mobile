
import 'package:flutter/material.dart' hide View;
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:tdv2_showcase_mobile/app/widget/main_text_field.dart';
import 'package:tdv2_showcase_mobile/app/widget/primary_elevated_button.dart';
import 'package:tdv2_showcase_mobile/data/repo/login_repository.dart';
import 'package:tdv2_showcase_mobile/domain/entity/notifiable_device.dart';

import 'verify_login_controller.dart';

class VerifyLoginSheet extends View {
  const VerifyLoginSheet({super.key, required this.phoneNumber, required this.meta, required this.notifiableDevices});

  final String phoneNumber;
  final String meta;
  final List<NotifiableDevice> notifiableDevices;

  @override
  State<StatefulWidget> createState() => _VerifyLoginSheetState();
}

class _VerifyLoginSheetState extends ViewState<VerifyLoginSheet, VerifyLoginController> {
  _VerifyLoginSheetState() : super(VerifyLoginController(DataLoginRepository()));

  final otpController = TextEditingController();

  @override
  Widget get view => Padding(
    key: globalKey,
    padding: const EdgeInsets.all(16.0).copyWith(top: 0),
    child: ControlledWidgetBuilder<VerifyLoginController>(
      builder: (context, controller) {
        switch (controller.state) {
          case VerifyLoginState.pickVerificationMethod:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Pick method to verify your identity.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: PrimaryElevatedButton(
                    onClick: () => controller.requestOtp(widget.phoneNumber, widget.meta),
                    label: 'OTP Method',
                  ),
                ),
                for (var device in widget.notifiableDevices) Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: PrimaryElevatedButton(
                    onClick: () => controller.sendNotification(widget.phoneNumber, widget.meta, device.id, '${device.name}, ${device.osVersion}'),
                    label: 'Notify device ${device.name}, ${device.osVersion}',
                  ),
                ),
              ],
            );
          case VerifyLoginState.inputOtp:
          case VerifyLoginState.otpLoading:
            final isLoading = controller.state == VerifyLoginState.otpLoading;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Enter otp code from the message we sent you.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: MainTextField(
                    controller: otpController,
                    label: 'OTP',
                  ),
                ),
                PrimaryElevatedButton(
                  onClick: isLoading
                      ? null
                      : () => controller.validateOtp(otpController.text, widget.phoneNumber, widget.meta),
                  label: 'Validate OTP',
                ),
              ],
            );
          case VerifyLoginState.otpFailed:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    'OTP verification failed. Either your inputted otp code is wrong or problem in the server. Please try again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                PrimaryElevatedButton(
                  onClick: () => controller.popWithResult(false),
                  label: 'Close',
                ),
              ],
            );
          case VerifyLoginState.notificationSent:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Please open your ${controller.selectedDevice ?? 'selected'} device and verify your identity. Then sign in again.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
                PrimaryElevatedButton(
                  onClick: () => controller.popWithResult(null),
                  label: 'Close',
                ),
              ],
            );
          case VerifyLoginState.notificationFailedToSend:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    'Failed to send notification. Please try again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                PrimaryElevatedButton(
                  onClick: () => controller.popWithResult(false),
                  label: 'Close',
                ),
              ],
            );
        }
      }
    ),
  );
}