import 'package:flutter/material.dart';
import 'package:tdv2_showcase_mobile/app/router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget with MyTheme {
  MyApp({super.key});

  final router = AppPageRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trusted Device V2 Showcase',
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        textTheme: textTheme,
      ),
      navigatorObservers: [router.routeObserver],
      onGenerateRoute: router.getRoute,
      initialRoute: AppPageRouter.login,
    );
  }
}

mixin MyTheme {
  final colorScheme = ColorScheme.fromSeed(seedColor: Colors.deepPurple);

  TextTheme get textTheme => const TextTheme(
    displayLarge: TextStyle(
      color: Colors.white,
      fontFamily: 'JosefinSans',
      fontWeight: FontWeight.w700,
      fontSize: 40.0,
    ),
    displayMedium: TextStyle(
      color: Colors.white,
      fontFamily: 'JosefinSans',
      fontWeight: FontWeight.w600,
      fontSize: 24.0,
    ),
    bodySmall: TextStyle(
      color: Colors.black,
      fontFamily: 'JosefinSans',
      fontWeight: FontWeight.w500,
      fontSize: 17.0,
    ),
  );
}
