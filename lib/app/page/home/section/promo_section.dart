
import 'package:flutter/material.dart';
import 'package:tdv2_showcase_mobile/app/widget/carousel.dart';
import 'package:tdv2_showcase_mobile/domain/entity/promo.dart';

class HomeViewPromoSection extends StatelessWidget {
  const HomeViewPromoSection({super.key, required this.isLoading, required this.height, required this.promos});

  final bool isLoading;
  final List<Promo> promos;
  final double height;

  final double imageWidthRatio = 40.0;
  final double imageHeightRatio = 18.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: height,
            child: Builder(
              builder: (context) {
                if (isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Carousel(
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              promos[i].imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            left: 0,
                            bottom: 0,
                            right: 0,
                            child: Text(
                              promos[i].name,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  itemsLength: promos.length,
                  imageAspectRatio: imageWidthRatio / imageHeightRatio,
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}
