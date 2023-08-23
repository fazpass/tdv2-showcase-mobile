
import 'package:flutter/material.dart';
import 'package:tdv2_showcase_mobile/app/page/home/home_view.dart';
import 'package:tdv2_showcase_mobile/app/page/login/login_view.dart';

class AppPageRouter {
  static const login = '/';
  static const home = '/home';

  final RouteObserver<PageRoute> routeObserver;

  AppPageRouter()
      : routeObserver = RouteObserver<PageRoute>();

  Route? getRoute(RouteSettings settings) {
    final Widget widget;
    switch (settings.name) {
      case home:
        widget = const HomeView();
        break;
      default:
        widget = const LoginView();
        break;
    }
    return MaterialPageRoute(builder: (c) => widget);
  }
}