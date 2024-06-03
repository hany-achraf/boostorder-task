import 'package:flutter/material.dart';

import '../../features/catalog/ui/pages/catalog_page.dart';
import '../../features/cart/ui/pages/cart_page.dart';
import 'routes.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.catalog:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const CatalogPage(),
        );
      case Routes.cart:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const CartPage(),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
