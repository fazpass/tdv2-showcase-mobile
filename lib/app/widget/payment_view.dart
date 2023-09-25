
import 'package:flutter/material.dart';
import 'package:tdv2_showcase_mobile/app/widget/main_text_field.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:tdv2_showcase_mobile/app/util/assets.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({super.key, required this.url, required this.onConfirmPayment});

  final String url;
  final Function() onConfirmPayment;

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {

  static const verifyPaymentCode = '1234';
  static const horizontalPadding = 12.0;

  late final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(NavigationDelegate(
      onNavigationRequest: (request) {
        if (request.url.contains('result=success') || request.url.contains('transaction_status=settlement')
            || request.url.contains('transaction_status=capture')) {
          widget.onConfirmPayment();
          return NavigationDecision.prevent;
        }
        else if (request.url.contains('example.com') || request.url.contains('result=error')) {
          Navigator.pop(context, false);
          return NavigationDecision.prevent;
        }

        return NavigationDecision.navigate;
      },
    ))
    ..loadRequest(Uri.parse(widget.url));
  final pageController = PageController(
    initialPage: 0,
    keepPage: false,
  );
  final verifyPaymentController = TextEditingController();

  String radioGroup = 'ovo';
  bool verifyCodeError = false;

  void pickVendor() {
    pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void confirmPayment() {
    if (verifyPaymentController.text == verifyPaymentCode) {
      widget.onConfirmPayment();
    } else {
      setState(() {
        verifyCodeError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) => /*WebViewWidget(
    gestureRecognizers: <Factory<VerticalDragGestureRecognizer>>{
      Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()),
    },
    controller: controller,
  );*/
  Container(
    height: 600,
    child: PageView(
      controller: pageController,
      children: [
        pickVendorPage(),
        confirmPaymentPage(),
      ],
    ),
  );

  Widget pickVendorPage() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
    child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 12, top: 16),
              child: Text(
                'Payment Method',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0),
              child: Text(
                'E-Wallet',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            _radioTile(imageAsset: AppAssets.ovoLogo, title: 'OVO', value: 'ovo'),
            _radioTile(imageAsset: AppAssets.danaLogo, title: 'DANA', value: 'dana'),
            _radioTile(imageAsset: AppAssets.gopayLogo, title: 'GoPay', value: 'gopay'),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0),
              child: Text(
                'Virtual Account Bank',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            _radioTile(imageAsset: AppAssets.bniLogo, title: 'BNI Virtual Account', value: 'bni'),
            _radioTile(imageAsset: AppAssets.bcaLogo, title: 'BCA Virtual Account', value: 'bca'),
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.green),
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                ),
                onPressed: pickVendor,
                child: const Text('Choose Vendor'),
              ),
            ),
          ],
        ),
      ),
  );

  Widget confirmPaymentPage() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
    child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 12, top: 16),
              child: Text(
                'Type "$verifyPaymentCode" in the field to successfully finish payment simulation.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: MainTextField(
                controller: verifyPaymentController,
                label: 'Verify Code',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.green),
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                ),
                onPressed: confirmPayment,
                child: const Text('Confirm Payment'),
              ),
            ),
            if (verifyCodeError) const Padding(
              padding: EdgeInsets.only(top: 6.0),
              child: Text(
                'Verify code is wrong.',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
  );

  Widget _radioTile({required String imageAsset, required String title, required String value}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: RadioListTile(
      value: value,
      groupValue: radioGroup,
      onChanged: (v) => setState(() => radioGroup = value),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      tileColor: Colors.white,
      selectedTileColor: Colors.white,
      title: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(imageAsset),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(title),
          ),
        ],
      ),
    ),
  );
}