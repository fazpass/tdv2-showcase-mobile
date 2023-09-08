
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({super.key, required this.url, required this.onConfirmPayment});

  final String url;
  final Function() onConfirmPayment;

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {

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

  @override
  Widget build(BuildContext context) => WebViewWidget(
    gestureRecognizers: <Factory<VerticalDragGestureRecognizer>>{
      Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer()),
    },
    controller: controller,
  );

  /*return SizedBox(
      height: 600,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 12, top: 24),
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
              child: Center(
                child: ElevatedButton(
                  onPressed: widget.onConfirmPayment,
                  child: const Text('Confirm Payment'),
              ),
              ),
            ),
          ],
        ),
      ),
    );*/

  //String radioGroup = 'ovo';

  /*Widget _radioTile({required String imageAsset, required String title, required String value}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: RadioListTile(
      value: value,
      groupValue: radioGroup,
      onChanged: (v) => setState(() => radioGroup = value),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      tileColor: Colors.white,
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
  );*/
}