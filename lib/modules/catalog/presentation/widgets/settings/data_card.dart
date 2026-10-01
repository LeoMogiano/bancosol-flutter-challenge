import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:warehouse/core/i18n/failure_i18n.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/modules/catalog/application/preferences/preferences_cubit.dart';
import 'package:warehouse/modules/catalog/application/products/products_bloc.dart';
import 'package:warehouse/shared/widgets/cards/app_card.dart';
import 'package:warehouse/shared/widgets/feedback/app_toast.dart';
import 'package:warehouse/shared/widgets/lists/app_switch_tile.dart';
import 'package:warehouse/shared/widgets/lists/app_tile.dart';

class DataCard extends StatelessWidget {
  const DataCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const _CacheTile(),
          Divider(height: 1, color: context.colors.line),
          const _SyncTile(),
        ],
      ),
    );
  }
}

class _CacheTile extends StatelessWidget {
  const _CacheTile();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final enabled = context.select<PreferencesCubit, bool>((cubit) => cubit.state.cacheEnabled);

    return AppSwitchTile(
      icon: Icons.offline_bolt_outlined,
      title: t.settings.cache,
      subtitle: t.settings.cacheHint,
      value: enabled,
      onChanged: (value) => context.read<PreferencesCubit>().setCacheEnabled(enabled: value),
    );
  }
}

class _SyncTile extends StatelessWidget {
  const _SyncTile();

  Future<void> _sync(BuildContext context) async {
    final t = context.t;
    final bloc = context.read<ProductsBloc>()..add(const ProductsRefreshed());
    final state = await bloc.stream.firstWhere((s) => !s.isRefreshing);
    if (!context.mounted) return;
    final failure = state.failure;
    failure == null
        ? AppToast.show(context, t.toasts.synced)
        : AppToast.show(context, failure.message, icon: Icons.error_rounded);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final data = context.select<ProductsBloc, ({DateTime? syncedAt, bool refreshing})>(
      (bloc) => (syncedAt: bloc.state.syncedAt, refreshing: bloc.state.isRefreshing),
    );
    final syncedAt = data.syncedAt;

    return AppTile(
      icon: Icons.sync_rounded,
      title: t.settings.syncNow,
      subtitle: syncedAt == null ? t.settings.neverSynced : t.settings.syncedAt(time: DateFormat.Hm().format(syncedAt)),
      onTap: data.refreshing ? null : () => _sync(context),
      trailing: data.refreshing
          ? SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2, color: colors.accent))
          : Icon(Icons.chevron_right_rounded, color: colors.ink3),
    );
  }
}
