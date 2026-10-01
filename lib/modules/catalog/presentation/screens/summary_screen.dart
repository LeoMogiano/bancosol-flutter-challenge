import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/i18n/failure_i18n.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/modules/catalog/application/preferences/preferences_cubit.dart';
import 'package:warehouse/modules/catalog/application/products/products_bloc.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/services/product_query.dart';
import 'package:warehouse/modules/catalog/presentation/shell/main_shell.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/inventory_card.dart';
import 'package:warehouse/shared/widgets/buttons/app_button.dart';
import 'package:warehouse/shared/widgets/buttons/app_icon_button.dart';
import 'package:warehouse/shared/widgets/cards/stat_tile.dart';
import 'package:warehouse/shared/widgets/feedback/app_state_view.dart';
import 'package:warehouse/shared/widgets/feedback/app_toast.dart';
import 'package:warehouse/shared/widgets/feedback/skeleton_box.dart';
import 'package:warehouse/shared/widgets/layout/app_top_bar.dart';
import 'package:warehouse/shared/widgets/layout/custom_scaffold.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  bool _refreshStartedLocally = false;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return CustomScaffold(
      scrollable: true,
      padding: EdgeInsets.zero,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 130),
        child: Column(
          children: [
            AppTopBar.large(
              eyebrow: t.summary.eyebrow,
              title: t.summary.title,
              actions: [
                BlocSelector<PreferencesCubit, PreferencesState, ThemeMode>(
                  selector: (state) => state.themeMode,
                  builder: (context, themeMode) => AppIconButton(
                    icon: context.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    tooltip: context.isDarkMode ? t.theme.light : t.theme.dark,
                    onPressed: () {
                      final nextMode = context.isDarkMode ? ThemeMode.light : ThemeMode.dark;
                      unawaited(context.read<PreferencesCubit>().setThemeMode(nextMode));
                    },
                  ),
                ),
                AppIconButton(
                  icon: Icons.sync_rounded,
                  tooltip: t.settings.syncNow,
                  onPressed: () {
                    _refreshStartedLocally = true;
                    context.read<ProductsBloc>().add(const ProductsRefreshed());
                  },
                ),
              ],
            ),
            const SizedBox(height: 4),
            _FakeSearchButton(label: t.summary.searchHint),
            const SizedBox(height: 20),
            BlocListener<ProductsBloc, ProductsState>(
              listenWhen: (prev, curr) => _refreshStartedLocally && prev.isRefreshing && !curr.isRefreshing,
              listener: (context, state) {
                _refreshStartedLocally = false;
                if (state.failure == null) {
                  AppToast.show(context, t.toasts.synced);
                } else {
                  AppToast.show(context, state.failure!.message, icon: Icons.error_rounded);
                }
              },
              child: BlocSelector<ProductsBloc, ProductsState, ProductsStatus>(
                selector: (state) => state.status,
                builder: (context, status) {
                  if (status == ProductsStatus.loading || status == ProductsStatus.initial) {
                    return _LoadingState();
                  } else if (status == ProductsStatus.failure) {
                    return AppStateView(
                      type: AppStateType.error,
                      title: t.summary.errorTitle,
                      message: t.summary.errorMessage,
                      actions: [
                        AppButton(
                          label: t.actions.retry,
                          onPressed: () => context.read<ProductsBloc>().add(const ProductsRequested()),
                        ),
                      ],
                    );
                  }
                  return BlocSelector<ProductsBloc, ProductsState, ({List<Product> all, DateTime? syncedAt})>(
                    selector: (state) => (all: state.all, syncedAt: state.syncedAt),
                    builder: (context, data) {
                      if (data.all.isEmpty) {
                        return AppStateView(
                          type: AppStateType.empty,
                          title: t.summary.emptyTitle,
                          message: t.summary.emptyMessage,
                          actions: [
                            AppButton(label: t.actions.newProduct, onPressed: null),
                            AppButton(
                              label: t.actions.refresh,
                              variant: AppButtonVariant.outline,
                              onPressed: () => context.read<ProductsBloc>().add(const ProductsRefreshed()),
                            ),
                          ],
                        );
                      }
                      final totalBob = data.all.fold<double>(
                        0,
                        (sum, p) => sum + (ProductQuery.priceInBob(p) * p.stock),
                      );
                      final outOfStock = data.all.where((p) => p.stock == 0).length;
                      final lowStock = data.all.where((p) => p.stock > 0 && p.stock <= 5).length;
                      return Column(
                        children: [
                          InventoryCard(totalBob: totalBob, syncedAt: data.syncedAt),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: StatTile(
                                  label: t.summary.statProducts,
                                  value: data.all.length.toString(),
                                  color: context.colors.accent,
                                  onTap: () => StatefulNavigationShell.of(context).goBranch(1),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: StatTile(
                                  label: t.summary.statLowStock,
                                  value: lowStock.toString(),
                                  color: context.colors.warn,
                                  onTap: () => StatefulNavigationShell.of(context).goBranch(1),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: StatTile(
                                  label: t.summary.statOutOfStock,
                                  value: outOfStock.toString(),
                                  color: context.colors.bad,
                                  onTap: () => StatefulNavigationShell.of(context).goBranch(1),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SkeletonBox(height: 132, radius: 24),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: SkeletonBox(height: 84, radius: 20)),
            SizedBox(width: 10),
            Expanded(child: SkeletonBox(height: 84, radius: 20)),
            SizedBox(width: 10),
            Expanded(child: SkeletonBox(height: 84, radius: 20)),
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: SkeletonBox(height: 64, radius: 20)),
            SizedBox(width: 10),
            Expanded(child: SkeletonBox(height: 64, radius: 20)),
            SizedBox(width: 10),
            Expanded(child: SkeletonBox(height: 64, radius: 20)),
          ],
        ),
      ],
    );
  }
}

class _FakeSearchButton extends StatelessWidget {
  const _FakeSearchButton({required this.label});

  static const double _height = 52;

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.surface,
      shape: StadiumBorder(side: BorderSide(color: colors.line)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () {
          context.read<SearchFocusRequest>().request();
          StatefulNavigationShell.of(context).goBranch(1);
        },
        child: SizedBox(
          height: _height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Icon(Icons.search_rounded, size: 22, color: colors.ink2),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(fontSize: 15.sp, color: colors.ink3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
