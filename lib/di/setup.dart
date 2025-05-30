import 'package:get_it/get_it.dart' show GetIt;
import 'package:kib_flutter_utils/kib_flutter_utils.dart' show ExceptionX;
import 'package:kib_sales_force/core/preferences/shared_preferences_manager.dart'
    show AppPrefs, AppPrefsAsyncManager;
import 'package:kib_utils/kib_utils.dart' show Result, tryResultAsync;

final getIt = GetIt.instance;

/// Setup all service dependencies
Future<Result<bool, Exception>> setupServiceLocator() async {
  return await tryResultAsync<bool, Exception>(
    () async {
      _setupAppPrefs();
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
