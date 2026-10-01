import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/shared/widgets/cards/app_card.dart';
import 'package:warehouse/shared/widgets/feedback/app_toast.dart';
import 'package:warehouse/shared/widgets/lists/app_tile.dart';

class SentryTestCard extends StatelessWidget {
  const SentryTestCard({super.key});

  Future<void> _sendTestError(BuildContext context) async {
    final t = context.t;
    if (!Sentry.isEnabled) {
      AppToast.showInfo(context, t.toasts.sentryDisabled);
      return;
    }
    final id = await Sentry.captureException(
      StateError('Sentry test error from Settings'),
      stackTrace: StackTrace.current,
    );
    if (!context.mounted) return;
    AppToast.showSuccess(
      context,
      t.toasts.sentrySent(id: id.toString().substring(0, 8)),
      icon: Icons.bug_report_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AppTile(
        icon: Icons.bug_report_outlined,
        title: t.settings.sentryTest,
        subtitle: t.settings.sentryTestHint,
        trailing: Icon(Icons.chevron_right_rounded, color: context.colors.ink3),
        onTap: () => _sendTestError(context),
      ),
    );
  }
}
