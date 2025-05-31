import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart' show GoRoute, GoRouter, GoRouterState, RouteBase, ShellRoute;
import 'package:kib_debug_print/kib_debug_print.dart' show kprint;
import 'package:kib_sales_force/core/preferences/shared_preferences_manager.dart'
    show AppPrefsAsyncManager;
import 'package:kib_sales_force/presentation/screens/auth/sign_in/sign_in_screen.dart'
    show SignInScreen;
import 'package:kib_sales_force/presentation/screens/auth/sign_up/sign_up_screen.dart'
    show SignUpScreen;
import 'package:kib_sales_force/presentation/screens/home/home_screen.dart'
    show HomeScreenProviderUtil;
import 'package:kib_sales_force/presentation/screens/visits/create_visit_screen.dart'
    show CreateVisitScreen;
import 'package:kib_sales_force/presentation/screens/visits/visit_details_screen.dart'
    show VisitDetailsScreen;
import 'package:kib_sales_force/presentation/screens/visits/visit_list_screen.dart'
    show VisitListScreen;
import 'package:kib_sales_force/presentation/screens/customers/customer_list_screen.dart'
    show CustomerListScreen;
import 'package:kib_sales_force/presentation/screens/customers/customer_details_screen.dart'
    show CustomerDetailsScreen;
import 'package:kib_sales_force/presentation/screens/statistics/statistics_screen.dart'
    show StatisticsScreen;
import 'package:kib_sales_force/presentation/widgets/app_bottom_navigation.dart'
    show AppBottomNavigation;

class AppRoute {
  final String name;
  final String path;
  final bool requiresAuth;
  const AppRoute({
    required this.name,
    required this.path,
    this.requiresAuth = false,
  });
}

class AppRoutes {
  // Auth Routes
  static const AppRoute root = AppRoute(name: 'Root', path: '/');
  static const AppRoute signUp = AppRoute(name: 'Sign-Up', path: '/sign-up');
  static const AppRoute signIn = AppRoute(name: 'Sign-In', path: '/sign-in');
  
  // Main App Routes
  static const AppRoute home = AppRoute(
    name: 'Home',
    path: '/home',
    requiresAuth: true,
  );
  
  // Visit Management Routes
  static const AppRoute createVisit = AppRoute(
    name: 'CreateVisit',
    path: '/visits/create',
    requiresAuth: true,
  );
  static const AppRoute visitDetails = AppRoute(
    name: 'VisitDetails',
    path: '/visits/:id',
    requiresAuth: true,
  );
  static const AppRoute visitList = AppRoute(
    name: 'VisitList',
    path: '/visits',
    requiresAuth: true,
  );
  
  // Customer Management Routes
  static const AppRoute customerList = AppRoute(
    name: 'CustomerList',
    path: '/customers',
    requiresAuth: true,
  );
  static const AppRoute customerDetails = AppRoute(
    name: 'CustomerDetails',
    path: '/customers/:id',
    requiresAuth: true,
  );
  
  // Statistics Routes
  static const AppRoute statistics = AppRoute(
    name: 'Statistics',
    path: '/statistics',
    requiresAuth: true,
  );
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
        debugLogDiagnostics: true,
        routes: _routes(prefsManager),
        redirect: (context, state) => _handleRedirect(context, state, prefsManager),
        errorBuilder: (context, state) => _buildErrorScreen(state),
      );

      _initialized = true;
    } catch (e) {
      _initialized = false;
      throw StateError('Failed to initialize AppNavigation: $e');
    }
  }

  static Future<String?> _handleRedirect(
    BuildContext context,
    GoRouterState state,
    AppPrefsAsyncManager prefsManager,
  ) async {
    final isAuthenticated = (await prefsManager.getCurrentUserUid())?.isNotEmpty == true;
    final isAuthRoute = state.matchedLocation == AppRoutes.signIn.path ||
        state.matchedLocation == AppRoutes.signUp.path;

    // If not authenticated and trying to access protected route
    if (!isAuthenticated && !isAuthRoute) {
      return AppRoutes.signIn.path;
    }

    // If authenticated and trying to access auth routes
    if (isAuthenticated && isAuthRoute) {
      return AppRoutes.home.path;
    }

    return null;
  }

  static Widget _buildErrorScreen(GoRouterState state) {
    return Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    );
  }

  static List<RouteBase> _routes(AppPrefsAsyncManager prefsManager) {
    return [
      // Auth Routes
      GoRoute(
        path: AppRoutes.root.path,
        name: AppRoutes.root.name,
        builder: (context, state) => SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.signIn.path,
        name: AppRoutes.signIn.name,
        builder: (context, state) => SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUp.path,
        name: AppRoutes.signUp.name,
        builder: (context, state) => SignUpScreen(),
      ),

      // Main App Shell Route
      ShellRoute(
        builder: (context, state, child) {
          return Scaffold(
            body: child,
            bottomNavigationBar: AppBottomNavigation(
              currentPath: state.matchedLocation,
            ),
          );
        },
        routes: [
          // Home Route
          GoRoute(
            path: AppRoutes.home.path,
            name: AppRoutes.home.name,
            builder: (context, state) => HomeScreenProviderUtil(),
          ),

          // Visit Management Routes
          GoRoute(
            path: AppRoutes.createVisit.path,
            name: AppRoutes.createVisit.name,
            builder: (context, state) => const CreateVisitScreen(),
          ),
          GoRoute(
            path: AppRoutes.visitDetails.path,
            name: AppRoutes.visitDetails.name,
            builder: (context, state) {
              final visitId = state.pathParameters['id'];
              return VisitDetailsScreen(visitId: visitId!);
            },
          ),
          GoRoute(
            path: AppRoutes.visitList.path,
            name: AppRoutes.visitList.name,
            builder: (context, state) => const VisitListScreen(),
          ),

          // Customer Management Routes
          GoRoute(
            path: AppRoutes.customerList.path,
            name: AppRoutes.customerList.name,
            builder: (context, state) => const CustomerListScreen(),
          ),
          GoRoute(
            path: AppRoutes.customerDetails.path,
            name: AppRoutes.customerDetails.name,
            builder: (context, state) {
              final customerId = state.pathParameters['id'];
              return CustomerDetailsScreen(customerId: customerId!);
            },
          ),

          // Statistics Route
          GoRoute(
            path: AppRoutes.statistics.path,
            name: AppRoutes.statistics.name,
            builder: (context, state) => const StatisticsScreen(),
          ),
        ],
      ),
    ];
  }
}
