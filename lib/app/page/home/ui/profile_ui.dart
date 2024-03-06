
import 'package:flutter/material.dart' hide View;
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:tdv2_showcase_mobile/app/page/home/home_controller.dart';

class ProfileUI extends StatelessWidget {
  const ProfileUI({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = FlutterCleanArchitecture.getController(context);
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(26.0).copyWith(top: 60, bottom: 50),
                child: const CircleAvatar(
                  radius: 50,
                  child: Icon(
                    Icons.person,
                    size: 80,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: controller.openSettings,
              ),
              ListTile(
                leading: const Icon(Icons.phonelink_erase),
                title: const Text('Remove Device'),
                onTap: controller.removeDevice,
              ),
              ListTile(
                leading: const Icon(Icons.power_settings_new),
                title: const Text('Logout'),
                onTap: controller.logout,
              ),
            ],
          ),
        ),
      ],
    );
  }

}