
import 'package:flutter/material.dart' hide View;
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:tdv2_showcase_mobile/app/widget/main_text_field.dart';
import 'package:tdv2_showcase_mobile/app/widget/primary_elevated_button.dart';
import 'package:tdv2_showcase_mobile/data/repo/login_repository.dart';

import 'validate_otp_controller.dart';

class ValidateOtpSheet extends View {
  const ValidateOtpSheet({super.key, required this.otpId, required this.phoneNumber, required this.meta});

  final String otpId;
  final String phoneNumber;
  final String meta;

  @override
  State<StatefulWidget> createState() => _ValidateOtpSheetState();
}

class _ValidateOtpSheetState extends ViewState<ValidateOtpSheet, ValidateOtpController> {
  _ValidateOtpSheetState() : super(ValidateOtpController(DataLoginRepository()));

  final otpController = TextEditingController();

  @override
  Widget get view => Padding(
    key: globalKey,
    padding: const EdgeInsets.all(16.0).copyWith(top: 0),
    child: Column(
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
        ControlledWidgetBuilder<ValidateOtpController>(
          builder: (context, controller) {
            return PrimaryElevatedButton(
              onClick: controller.isLoading
                  ? null
                  : () => controller.otpValidation(widget.otpId, otpController.text, widget.phoneNumber, widget.meta),
              label: 'Validate OTP',
            );
          },
        ),
      ],
    ),
  );
}