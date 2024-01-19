import 'dart:async';

import 'package:flutter/material.dart';
import 'package:newrelic_mobile/config.dart';
import 'package:newrelic_mobile/newrelic_navigation_observer.dart';
import 'package:tdv2_showcase_mobile/app/router.dart';
import 'package:newrelic_mobile/newrelic_mobile.dart';


void main() {
  const newRelicToken = "AA3e24ea131fd2820857b681c3961dda66142706d3-NRMA";

  Config config = Config(accessToken: newRelicToken,
    // Optional: Enable or disable collection of event data.
    analyticsEventEnabled: true,
    // Optional: Enable or disable reporting successful HTTP requests to the MobileRequest event type.
    networkErrorRequestEnabled: true,
    // Optional: Enable or disable reporting network and HTTP request errors to the MobileRequestError event type.
    networkRequestEnabled: true,
    // Optional: Enable or disable crash reporting.
    crashReportingEnabled: true,
    // Optional: Enable or disable interaction tracing. Trace instrumentation still occurs, but no traces are harvested. This will disable default and custom interactions.
    interactionTracingEnabled: true,
    // Optional: Enable or disable capture of HTTP response bodies for HTTP error traces, and MobileRequestError events.
    httpResponseBodyCaptureEnabled: false,
    // Optional: Enable or disable agent logging.
    loggingEnabled: true,
    // Optional: Enable or disable print statements as Analytics Events.
    printStatementAsEventsEnabled : false,
    // Optional: Enable or disable automatic instrumentation of HTTP requests.
    httpInstrumentationEnabled: false
  );

  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = NewrelicMobile.onError;
    await NewrelicMobile.instance.startAgent(config);
    runApp(MyApp());
  }, (Object error, StackTrace stackTrace) {
    NewrelicMobile.instance.recordError(error, stackTrace);
  });
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
      navigatorObservers: [
        router.routeObserver,
        NewRelicNavigationObserver(),
      ],
      onGenerateRoute: router.getRoute,
      initialRoute: AppPageRouter.login,
    );
  }
}

mixin MyTheme {
  final colorScheme = ColorScheme.fromSeed(seedColor: Colors.deepPurple);

  TextTheme get textTheme => const TextTheme(
    displayLarge: TextStyle(
      color: Colors.black,
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
