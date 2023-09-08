
import 'package:flutter/material.dart' hide View;
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:tdv2_showcase_mobile/app/page/home/home_controller.dart';

class TopupUI extends StatelessWidget {
  const TopupUI({super.key});

  static const topupAmounts = <int>[
    10000,
    20000,
    50000,
    100000,
    200000,
    500000,
  ];

  @override
  Widget build(BuildContext context) {
    HomeController controller = FlutterCleanArchitecture.getController(context);
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0).copyWith(top: 50),
          sliver: SliverToBoxAdapter(
            child: Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.payment,
                      color: Colors.blue,
                      size: 40,
                    ),
                    Text(
                      'Rp. ${controller.balanceAmount}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 20.0,
              crossAxisSpacing: 20.0,
            ),
            delegate: SliverChildListDelegate.fixed([
              for (var topupAmount in topupAmounts) ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                    controller.pickedAmount == topupAmount ? Colors.blue : Colors.white,
                  ),
                  shape: MaterialStatePropertyAll<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                ),
                onPressed: () => controller.changePickedAmount(topupAmount),
                child: Text(
                  'Rp. ${topupAmount~/1000}k',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontSize: 14,
                    color: controller.pickedAmount == topupAmount ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ]),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.topup,
                    child: Text(
                      'Topup',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

}