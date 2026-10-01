import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/core/i18n/failure_i18n.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/modules/catalog/application/preferences/preferences_cubit.dart';
import 'package:warehouse/modules/catalog/application/products/products_bloc.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/summary/search_redirect_button.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/summary/summary_body.dart';
import 'package:warehouse/shared/widgets/buttons/app_icon_button.dart';
import 'package:warehouse/shared/widgets/feedback/app_toast.dart';
import 'package:warehouse/shared/widgets/layout/app_top_bar.dart';
import 'package:warehouse/shared/widgets/layout/custom_scaffold.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  bool _refreshStartedLocally = false;

  Future<void> _refresh() async {
    _refreshStartedLocally = true;
    context.read<ProductsBloc>().add(const ProductsRefreshed());
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return BlocListener<ProductsBloc, ProductsState>(
      listenWhen: (prev, curr) => _refreshStartedLocally && prev.isRefreshing && !curr.isRefreshing,
      listener: (context, state) {
        _refreshStartedLocally = false;
        final failure = state.failure;
        if (failure == null) {
          AppToast.showSuccess(context, t.toasts.synced);
        } else {
          AppToast.showError(context, failure.message);
        }
      },
      child: CustomScaffold(
        scrollable: true,
        onRefresh: _refresh,
        padding: EdgeInsets.zero,
        body: Padding(
          padding: const EdgeInsets.only(bottom: 130),
          child: Column(
            children: [
              AppTopBar.large(eyebrow: t.summary.eyebrow, title: t.summary.title, actions: const [_ThemeToggle()]),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                child: Column(
                  spacing: 20,
                  children: [
                    SearchRedirectButton(label: t.summary.searchHint),
                    const SummaryBody(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final isDark = context.isDarkMode;

    return AppIconButton(
      icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
      tooltip: isDark ? t.theme.light : t.theme.dark,
      onPressed: () {
        final nextMode = isDark ? ThemeMode.light : ThemeMode.dark;
        unawaited(context.read<PreferencesCubit>().setThemeMode(nextMode));
      },
    );
  }
}
