
import 'package:flutter/material.dart';
import 'package:tdv2_showcase_mobile/app/widget/product_item_view.dart';
import 'package:tdv2_showcase_mobile/domain/entity/product.dart';

class HomeViewProductSection extends StatelessWidget {
  const HomeViewProductSection({super.key, required this.isLoading, required this.products});

  final bool isLoading;
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recommended Products',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  'View all >>',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 265.0,
            child: Builder(
              builder: (context) {
                if (isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: products.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, i) {
                    return ProductItemView(product: products[i]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
