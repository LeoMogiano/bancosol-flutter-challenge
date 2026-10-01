import 'package:go_router/go_router.dart';
import 'package:warehouse/app/router/app_routes.dart';
import 'package:warehouse/modules/catalog/presentation/screens/home_placeholder_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [GoRoute(path: AppRoutes.home, builder: (_, _) => const HomePlaceholderScreen())],
);
