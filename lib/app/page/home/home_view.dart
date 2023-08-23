
import 'package:flutter/material.dart' hide View;
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:tdv2_showcase_mobile/app/page/home/home_controller.dart';
import 'package:tdv2_showcase_mobile/app/page/home/section/category_section.dart';
import 'package:tdv2_showcase_mobile/app/page/home/section/product_section.dart';
import 'package:tdv2_showcase_mobile/app/page/home/section/promo_section.dart';
import 'package:tdv2_showcase_mobile/app/page/home/section/tenant_section.dart';
import 'package:tdv2_showcase_mobile/app/widget/primary_bottom_navbar.dart';
import 'package:tdv2_showcase_mobile/app/widget/search_field.dart';
import 'package:tdv2_showcase_mobile/data/repo/home_repository.dart';
import 'package:tdv2_showcase_mobile/device/repo/fazpass_repository.dart';

class HomeView extends View {
  const HomeView({super.key});

  @override
  State createState() => HomeViewState();
}

class HomeViewState extends ViewState<HomeView, HomeController> {
  HomeViewState() : super(HomeController(DataHomeRepository(), DeviceFazpassRepository()));

  @override
  Widget get view {
    var promoAspectRatio = 3/1;
    var toolbarAndPromoHeight = MediaQuery.of(context).size.height/promoAspectRatio;

    return Scaffold(
      key: globalKey,
      bottomNavigationBar: const PrimaryBottomNavigationBar(),
      body: ControlledWidgetBuilder<HomeController>(
        builder: (context, controller) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                titleSpacing: 12.0,
                title: const SearchField(),
                backgroundColor: Colors.transparent,
                forceMaterialTransparency: true,
                shadowColor: Colors.transparent,
                elevation: 0.0,
                actions: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.filter_alt_outlined,
                      color: Colors.black,
                    ),
                    onPressed: () {},
                  ),
                  PopupMenuButton<int>(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
                    onSelected: (i) {
                      switch (i) {
                        case 0:
                          controller.validate();
                          break;
                        case 1:
                          controller.logout();
                          break;
                      }
                    },
                    itemBuilder: (c) => [
                      const PopupMenuItem(
                        value: 0,
                        child: Text('Validate'),
                      ),
                      const PopupMenuItem(
                        value: 1,
                        child: Text('Logout'),
                      ),
                    ],
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 12.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate.fixed([
                    HomeViewPromoSection(
                      isLoading: controller.isLoadingPromos,
                      height: toolbarAndPromoHeight,
                      promos: controller.promos,
                    ),
                    HomeViewProductSection(
                      isLoading: controller.isLoadingProducts,
                      products: controller.products,
                    ),
                    HomeViewCategorySection(
                      isLoading: controller.isLoadingCategories,
                      categories: controller.categories,
                    ),
                    MainViewTenantSection(
                      isLoading: controller.isLoadingTenants,
                      tenants: controller.tenants,
                    ),
                  ]),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}