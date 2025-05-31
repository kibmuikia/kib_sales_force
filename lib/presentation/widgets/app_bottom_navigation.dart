import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kib_flutter_utils/kib_flutter_utils.dart';
import 'package:kib_sales_force/config/routes/router_config.dart'
    show AppRoutes;

class AppBottomNavigation extends StatelessWidgetK {
  final String currentPath;

  AppBottomNavigation({
    super.key,
    required this.currentPath,
    super.tag = 'AppBottomNavigation',
  });

  @override
  Widget buildWithTheme(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return BottomNavigationBar(
      currentIndex: _calculateSelectedIndex(currentPath),
      onTap: (index) => _onItemTapped(context, index),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: colorScheme.onSurface),
          activeIcon: Icon(Icons.home_outlined, color: colorScheme.onSurface),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list, color: colorScheme.onSurface),
          activeIcon: Icon(Icons.list_outlined, color: colorScheme.onSurface),
          label: 'Visits',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people, color: colorScheme.onSurface),
          activeIcon: Icon(Icons.people_outlined, color: colorScheme.onSurface),
          label: 'Customers',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart, color: colorScheme.onSurface),
          activeIcon:
              Icon(Icons.bar_chart_outlined, color: colorScheme.onSurface),
          label: 'Statistics',
        ),
      ],
    );
  }

  int _calculateSelectedIndex(String path) {
    if (path.startsWith(AppRoutes.home.path)) return 0;
    if (path.startsWith('/visits')) return 1;
    if (path.startsWith('/customers')) return 2;
    if (path.startsWith(AppRoutes.statistics.path)) return 3;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home.path);
        break;
      case 1:
        context.go(AppRoutes.visitList.path);
        break;
      case 2:
        context.go(AppRoutes.customerList.path);
        break;
      case 3:
        context.go(AppRoutes.statistics.path);
        break;
    }
  }
}
