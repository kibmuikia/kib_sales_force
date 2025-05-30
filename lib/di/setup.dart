import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:get_it/get_it.dart' show GetIt;
import 'package:kib_debug_print/kib_debug_print.dart' show kprint;
import 'package:kib_flutter_utils/kib_flutter_utils.dart' show ExceptionX;
import 'package:kib_sales_force/config/firebase_config/config.dart'
    show FirebaseHelper;
import 'package:kib_sales_force/config/routes/router_config.dart'
    show AppNavigation;
import 'package:kib_sales_force/core/preferences/shared_preferences_manager.dart'
    show AppPrefs, AppPrefsAsyncManager;
import 'package:kib_utils/kib_utils.dart' show Result, tryResultAsync;

final getIt = GetIt.instance;

/// Setup all service dependencies
Future<Result<bool, Exception>> setupServiceLocator() async {
  return await tryResultAsync<bool, Exception>(
    () async {
      _setupAppPrefs();
      await _setupFirebaseServices();
      _setupAppNavigation();
      return true;
    },
    (err) => err is Exception
        ? err
        : ExceptionX(
            message:
                "Error, ${err.runtimeType}, encountered while setting up services",
            errorType: err.runtimeType,
            error: err,
            stackTrace: StackTrace.current,
          ),
  );
}

/// Setup KibSalesForce Shared-Preferences
void _setupAppPrefs() {
  AppPrefs.init();

  if (!getIt.isRegistered<AppPrefsAsyncManager>()) {
    getIt.registerSingleton<AppPrefsAsyncManager>(AppPrefs.app);
  }
}

/// Setup Kib Sales Force Navigation
void _setupAppNavigation() {
  if (!AppPrefs.isInitialized) {
    AppPrefs.init();
  }

  if (!getIt.isRegistered<AppNavigation>()) {
    if (!AppNavigation.isInitialized) {
      AppNavigation.init(prefsManager: AppPrefs.app);
    }
    getIt.registerSingleton<AppNavigation>(AppNavigation.instance);
  }
}

/// Setup Firebase services
Future<Result<bool, Exception>> _setupFirebaseServices() async =>
    tryResultAsync(
      () async {
        final firebaseInitResult = await FirebaseHelper.initialize();
        kprint.lg(
            '_setupFirebaseServices:firebaseInitResult: $firebaseInitResult');
        if (firebaseInitResult.isFailure) {
          throw firebaseInitResult.errorOrNull!;
        }
        if (!getIt.isRegistered<FirebaseHelper>()) {
          getIt.registerSingleton<FirebaseHelper>(FirebaseHelper());
        }

        if (!getIt.isRegistered<FirebaseAuth>()) {
          getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
        }

        /* if (!getIt.isRegistered<FirebaseAuthService>()) {
          getIt.registerSingleton<FirebaseAuthService>(
            FirebaseAuthService(firebaseAuth: getIt<FirebaseAuth>()),
          );
        } */

        if (!getIt.isRegistered<FirebaseFirestore>()) {
          getIt
              .registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
        }

        return true;
      },
      (err) {
        kprint.err('_setupFirebaseServices:Error: $err');
        return err is Exception
            ? err
            : ExceptionX(
                message:
                    'Error, ${err.runtimeType}, encountered while setting up Firebase services',
                errorType: err.runtimeType,
                error: err,
                stackTrace: StackTrace.current,
              );
      },
    );
