
import 'package:flutter/material.dart';
import 'package:tdv2_showcase_mobile/domain/entity/tenant.dart';

class MainViewTenantSection extends StatelessWidget {
  const MainViewTenantSection({super.key, required this.isLoading, required this.tenants});

  final bool isLoading;
  final List<Tenant> tenants;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Tenants',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Builder(
            builder: (context) {
              if (isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Column(
                children: tenants.map((e) => Card(
                  child: SizedBox(
                    height: 100.0,
                    child: Row(
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(e.imageUrl, fit: BoxFit.cover,),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  e.name,
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.location_pin, color: Colors.black38, size: 12.0,),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          e.address,
                                          style: const TextStyle(
                                            color: Colors.black38,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}