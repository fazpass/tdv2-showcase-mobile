
import 'package:flutter/material.dart' hide View;
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:tdv2_showcase_mobile/data/repo/home_repository.dart';
import 'package:tdv2_showcase_mobile/device/repo/fazpass_repository.dart';

import 'validate_controller.dart';

class ValidateSheet extends View {
  const ValidateSheet({super.key});

  @override
  State<StatefulWidget> createState() => ValidateSheetState();
}

class ValidateSheetState extends ViewState<ValidateSheet, ValidateController> {
  ValidateSheetState() : super(ValidateController(DataHomeRepository(), DeviceFazpassRepository()));

  @override
  Widget get view => Padding(
    key: globalKey,
    padding: const EdgeInsets.all(16.0).copyWith(top: 0),
    child: ControlledWidgetBuilder<ValidateController>(
      builder: (context, controller) {
        if (!controller.hasValidate) controller.validate();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                controller.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (controller.confidenceValue != null) Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                '${controller.confidenceValue}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28.0,
                  color: Colors.black,
                ),
              ),
            ),
            if (controller.confidenceLevel != null) Text.rich(
              TextSpan(
                text: 'Risk level ',
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: controller.confidenceLevel!,
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            if (controller.confidenceValue == null) const SizedBox(
              height: 60.0,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        );
      },
    ),
  );
}