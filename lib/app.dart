import 'package:flutter/material.dart';
import 'package:kib_flutter_utils/kib_flutter_utils.dart';
import 'package:kib_sales_force/config/routes/router_config.dart'
    show AppNavigation;
import 'package:kib_sales_force/config/theme/app_theme.dart'
    show AppThemeConfig;
import 'package:kib_sales_force/core/constants/app_constants.dart' show appName;
import 'package:kib_sales_force/core/preferences/shared_preferences_manager.dart'
    show AppPrefsAsyncManager;
import 'package:kib_sales_force/di/setup.dart' show getIt;
import 'package:sizer/sizer.dart' show Sizer;

// This widget is the root of your application.
class KibSalesForce extends StatefulWidgetK {
  KibSalesForce({super.key, super.tag = 'KibSalesForce'});

  @override
  StateK<KibSalesForce> createState() => _KibSalesForceState();
}

class _KibSalesForceState extends StateK<KibSalesForce> {
  late final AppPrefsAsyncManager _prefs;

  @override
  void initState() {
    super.initState();

    _prefs = getIt<AppPrefsAsyncManager>();
    _updatePrefFirstLaunch();
  }

  void _updatePrefFirstLaunch() async {
    postFrame(() async {
      await _prefs.setFirstLaunch(false);
    });
  }

  @override
  Widget buildWithTheme(BuildContext context) {
    return _setupMaterialApp(context);
  }

  Widget _setupMaterialApp(BuildContext ctx) {
    return Sizer(
      builder: (context, orientation, screenType) {
        // return _setupGlobalProviders(context);
        return _materialApp(context);
      },
    );
  }

  MaterialApp _materialApp(BuildContext ctx) {
    return MaterialApp.router(
      title: appName,
      theme: AppThemeConfig.lightTheme,
      themeMode: ThemeMode.dark,
      darkTheme: AppThemeConfig.darkTheme,
      routerConfig: AppNavigation.appRouteConfig,
    );
  }

  //
}
