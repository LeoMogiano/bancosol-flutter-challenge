import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/theme/app_fonts.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/shared/widgets/buttons/app_icon_button.dart';

class AppTopBar extends StatelessWidget {
  const AppTopBar.large({required this.eyebrow, required this.title, this.actions = const [], super.key})
    : _compact = false,
      onBack = null,
      action = null;

  const AppTopBar.compact({required this.title, required this.onBack, this.action, super.key})
    : _compact = true,
      eyebrow = '',
      actions = const [];

  final bool _compact;
  final String eyebrow;
  final String title;
  final List<Widget> actions;
  final VoidCallback? onBack;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    if (_compact) return _buildCompact(context);
    return _buildLarge(context);
  }

  Widget _buildLarge(BuildContext context) {
    final eyebrowSize = 12.sp;
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eyebrow.toUpperCase(),
                  style: TextStyle(
                    fontSize: eyebrowSize,
                    fontWeight: FontWeight.w500,
                    color: colors.ink3,
                    letterSpacing: 0.14 * eyebrowSize,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22.65.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: AppFont.playfairDisplay.family,
                    color: colors.ink,
                    height: 1.05,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (actions.isNotEmpty) ...[const SizedBox(width: 12), Wrap(spacing: 8, children: actions)],
        ],
      ),
    );
  }

  Widget _buildCompact(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          AppIconButton(
            icon: Icons.arrow_back_rounded,
            onPressed: onBack,
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: colors.ink2),
            ),
          ),
          action ?? const SizedBox(width: 44, height: 44),
        ],
      ),
    );
  }
}
