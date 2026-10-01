import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/modules/catalog/application/products/products_bloc.dart';
import 'package:warehouse/shared/widgets/feedback/offline_badge.dart';
import 'package:warehouse/shared/widgets/navigation/app_nav_bar.dart';

// Queda pendiente si Productos aún no se construyó (IndexedStack crea las ramas al visitarlas).
class SearchFocusRequest {
  final ValueNotifier<int> _requests = ValueNotifier(0);
  bool _pending = false;

  Listenable get changes => _requests;

  void request() {
    _pending = true;
    _requests.value++;
  }

  bool consume() {
    final pending = _pending;
    _pending = false;
    return pending;
  }

  void dispose() => _requests.dispose();
}

class MainShell extends StatelessWidget {
  const MainShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return RepositoryProvider<SearchFocusRequest>(
      create: (_) => SearchFocusRequest(),
      dispose: (request) => request.dispose(),
      // Builder: el onSearch necesita un context por debajo del RepositoryProvider.
      child: Builder(
        builder: (context) => Stack(
          children: [
            navigationShell,
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocSelector<ProductsBloc, ProductsState, ({bool offline, DateTime? syncedAt})>(
                    selector: (state) => (offline: state.isOffline, syncedAt: state.syncedAt),
                    builder: (context, data) {
                      if (!data.offline) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(left: 20, bottom: 102),
                        child: OfflineBadge(
                          title: t.products.offline,
                          subtitle: data.syncedAt != null
                              ? t.products.lastSync(time: DateFormat.Hm().format(data.syncedAt!))
                              : t.settings.neverSynced,
                        ),
                      );
                    },
                  ),
                  AppNavBar(
                    items: [
                      AppNavItem(
                        icon: Icons.dashboard_rounded,
                        activeIcon: Icons.space_dashboard,
                        label: t.nav.summary,
                      ),
                      AppNavItem(
                        icon: Icons.inventory_2_rounded,
                        activeIcon: Icons.inventory_2_rounded,
                        label: t.nav.products,
                      ),
                      AppNavItem(
                        icon: Icons.settings_rounded,
                        activeIcon: Icons.settings_rounded,
                        label: t.nav.settings,
                      ),
                    ],
                    currentIndex: navigationShell.currentIndex,
                    onTap: (index) {
                      if (index == navigationShell.currentIndex) {
                        navigationShell.goBranch(index, initialLocation: true);
                      } else {
                        navigationShell.goBranch(index);
                      }
                    },
                    onSearch: () {
                      navigationShell.goBranch(1, initialLocation: navigationShell.currentIndex != 1);
                      context.read<SearchFocusRequest>().request();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
