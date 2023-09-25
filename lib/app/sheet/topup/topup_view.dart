
import 'package:flutter/material.dart' hide View;
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:tdv2_showcase_mobile/app/widget/payment_view.dart';
import 'package:tdv2_showcase_mobile/data/repo/home_repository.dart';
import 'package:tdv2_showcase_mobile/device/repo/fazpass_repository.dart';

import 'topup_controller.dart';

class TopupSheet extends View {
  const TopupSheet({super.key, required this.topupAmount});

  final int topupAmount;

  @override
  State<StatefulWidget> createState() => TopupSheetState();
}

class TopupSheetState extends ViewState<TopupSheet, TopupController> {
  TopupSheetState() : super(TopupController(DataHomeRepository(), DeviceFazpassRepository()));

  @override
  Widget get view => Padding(
    padding: const EdgeInsets.only(top: 24.0),
    child: SizedBox(
      key: globalKey,
      child: ControlledWidgetBuilder<TopupController>(
        builder: (context, controller) {
          controller.topupAmount = widget.topupAmount;
          // has loaded
          if (controller.confidenceValue != null && controller.riskLevel != null) {
            if (controller.riskLevel!.toLowerCase() == 'low') {
              if (controller.url?.isNotEmpty ?? false) {
                return PaymentView(url: controller.url!, onConfirmPayment: controller.onConfirmPayment);
              } else if (controller.url?.isEmpty ?? false) {
                return _errorView('Something went wrong. Please try again.');
              } else {
                return _loadingView('Loading payment...');
              }
            } else {
              return _errorView('It looks like your device isn\'t trusted enough. :)');
            }
          } else if (controller.confidenceValue == -1) {
            return _errorView('Something went wrong. Please check your internet connection.');
          }

          // still loading
          return _loadingView('Validating...');
        },
      ),
    ),
  );

  Widget _loadingView(String loadingTitle) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Text(
          loadingTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20.0,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      const SizedBox(
        height: 60.0,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ],
  );

  Widget _errorView(String message) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Padding(
        padding: EdgeInsets.only(bottom: 16.0),
        child: Text(
          'Oooops!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26.0,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20.0,
            color: Colors.black,
          ),
        ),
      ),
    ],
  );
}