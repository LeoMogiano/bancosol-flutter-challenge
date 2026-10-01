import 'package:flutter/material.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/shared/widgets/layout/app_top_bar.dart';
import 'package:warehouse/shared/widgets/layout/custom_scaffold.dart';

class SettingsPlaceholderScreen extends StatelessWidget {
  const SettingsPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return CustomScaffold(
      body: AppTopBar.large(eyebrow: t.settings.eyebrow, title: t.settings.title),
    );
  }
}
