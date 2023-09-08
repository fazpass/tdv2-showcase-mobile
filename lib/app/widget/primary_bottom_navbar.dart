import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:tdv2_showcase_mobile/app/page/home/home_controller.dart';

class PrimaryBottomNavigationBar extends StatefulWidget {

  const PrimaryBottomNavigationBar({super.key});

  @override
  State createState() => _PrimaryBottomNavigationBarState();
}

class _PrimaryBottomNavigationBarState extends State<PrimaryBottomNavigationBar> {

  @override
  Widget build(BuildContext context) {
    HomeController controller = FlutterCleanArchitecture.getController(context);
    return BottomNavigationBar(
      showUnselectedLabels: true,
      currentIndex: controller.pageIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.deepOrange,
      unselectedItemColor: Colors.grey.withOpacity(0.38),
      backgroundColor: Colors.white,
      elevation: 8.0,
      onTap: (index) {
        controller.changePageIndex(index);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.payment),
          label: 'Topup',
        ),
        // old code
        /*BottomNavigationBarItem(
          icon: Stack(
            children: [
              const Icon(Icons.shopping_cart),
              Positioned(
                top: 0.0,
                right: 0.0,
                child: Container(
                  padding: const EdgeInsets.all(1.0),
                  constraints: const BoxConstraints(
                      minWidth: 12.0,
                      minHeight: 12.0
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: const Center(
                    child: Text(
                      '3',
                      style: TextStyle(
                        fontSize: 8.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          label: 'Order',
        ),*/
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
