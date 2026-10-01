import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:warehouse/core/constants/app_routes.dart';
import 'package:warehouse/modules/catalog/presentation/screens/product_detail_screen.dart';
import 'package:warehouse/modules/catalog/presentation/screens/products_screen.dart';
import 'package:warehouse/modules/catalog/presentation/screens/settings_screen.dart';
import 'package:warehouse/modules/catalog/presentation/screens/summary_screen.dart';
import 'package:warehouse/modules/catalog/presentation/shell/main_shell.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.summary,
  navigatorKey: rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/products/:id',
      parentNavigatorKey: rootNavigatorKey,
      builder: (_, state) => ProductDetailScreen(remoteId: state.pathParameters['id']!),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => MainShell(navigationShell: shell),
      branches: [
        StatefulShellBranch(
          routes: [GoRoute(path: AppRoutes.summary, builder: (_, _) => const SummaryScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: AppRoutes.products, builder: (_, _) => const ProductsScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: AppRoutes.settings, builder: (_, _) => const SettingsScreen())],
        ),
      ],
    ),
  ],
);
