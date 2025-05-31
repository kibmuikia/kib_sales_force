import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRoute, GoRouter, RouteBase;
import 'package:kib_debug_print/kib_debug_print.dart' show kprint;
import 'package:kib_sales_force/core/preferences/shared_preferences_manager.dart'
    show AppPrefsAsyncManager;
import 'package:kib_sales_force/presentation/screens/auth/sign_in/sign_in_screen.dart'
    show SignInScreen;
import 'package:kib_sales_force/presentation/screens/auth/sign_up/sign_up_screen.dart'
    show SignUpScreen;
import 'package:kib_sales_force/presentation/screens/home/home_screen.dart'
    show HomeScreenProviderUtil;

class AppRoute {
  final String name;
  final String path;
  const AppRoute({required this.name, required this.path});
}

class AppRoutes {
  static const AppRoute root = AppRoute(name: 'Root', path: '/');
  static const AppRoute signUp = AppRoute(name: 'Sign-Up', path: '/sign-up');
  static const AppRoute signIn = AppRoute(name: 'Sign-In', path: '/sign-in');
  static const AppRoute home = AppRoute(name: 'Home', path: '/home');
}

class AppNavigation {
  AppNavigation._();

  static AppNavigation get instance => AppNavigation._();

  static bool _initialized = false;
  static bool get isInitialized => _initialized;

  static final GlobalKey<NavigatorState> appRootNavigatorStateKey =
      GlobalKey<NavigatorState>(debugLabel: 'appRootNavigatorStateKey');

  static late final GoRouter _appRouteConfig;

  static GoRouter get appRouteConfig {
    if (!_initialized) {
      throw StateError('AppNavigation has not been initialized');
    }
    return _appRouteConfig;
  }

  static void reset() {
    if (!_initialized) return;
    _initialized = false;
  }

  static void init({required AppPrefsAsyncManager prefsManager}) async {
    if (_initialized) {
      return;
    }
    try {
      final isAuthenticated =
          (await prefsManager.getCurrentUserUid())?.isNotEmpty == true;
      kprint.lg('router_config:init:isAuthenticated: $isAuthenticated');

      final initialLocation = isAuthenticated
          ? AppRoutes.home.path
          : AppRoutes.signIn.path;

      _appRouteConfig = GoRouter(
        navigatorKey: appRootNavigatorStateKey,
        initialLocation: initialLocation,
        routes: _routes(prefsManager),
      );

      _initialized = true;
    } catch (e) {
      _initialized = false;
      throw StateError('Failed to initialize AppNavigation: $e');
    }
  }

  static List<RouteBase> _routes(AppPrefsAsyncManager prefsManager) {
    return [
      GoRoute(
        path: AppRoutes.root.path,
        name: AppRoutes.root.name,
        builder: (context, state) => SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.signIn.path,
        name: AppRoutes.signIn.name,
        builder: (context, state) => SignInScreen(),
        redirect: (context, state) async {
          if ((await prefsManager.getCurrentUserUid())?.isNotEmpty == true) {
            return AppRoutes.home.path;
          }
          return null;
        },
      ),
      GoRoute(
        path: AppRoutes.signUp.path,
        name: AppRoutes.signUp.name,
        builder: (context, state) => SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.home.path,
        name: AppRoutes.home.name,
        builder: (context, state) => HomeScreenProviderUtil(),
      ),
    ];
  }

  //
}
