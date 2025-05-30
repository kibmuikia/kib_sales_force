import 'dart:async' show runZonedGuarded;

import 'package:flutter/foundation.dart'
    show FlutterError, PlatformDispatcher, kDebugMode;
import 'package:flutter/material.dart'
    show FlutterErrorDetails, WidgetsFlutterBinding, runApp;
import 'package:kib_debug_print/kib_debug_print.dart'
    show DebugPrintService, kprint;
import 'package:kib_sales_force/app.dart' show KibSalesForce;
import 'package:kib_sales_force/di/setup.dart';
import 'package:kib_utils/kib_utils.dart';

part 'main_ext.dart';

void main() {
  // Catch Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    _handleError('FlutterError', details);
  };

  // Catch platform errors
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    _handleError(
      'PlatformDispatcher',
      FlutterErrorDetails(
        exception: error,
        stack: stack,
        library: 'PlatformDispatcher',
      ),
    );
    return true;
  };

  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await _initializeCoreServices();

      runApp(KibSalesForce());
    },
    (Object error, StackTrace stackTrace) {
      _handleError(
        'ZonedGuarded',
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'ZonedGuarded',
        ),
      );
    },
  );
}
