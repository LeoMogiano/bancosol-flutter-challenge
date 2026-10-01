import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/theme/app_colors.dart';
import 'package:warehouse/core/theme/theme_context.dart';

enum AppStateType { error, empty, noResults }

class AppStateView extends StatelessWidget {
  const AppStateView({
    required this.type,
    required this.title,
    required this.message,
    this.actions = const [],
    super.key,
  });

  final AppStateType type;
  final String title;
  final String message;
  static const double _messageMaxWidth = 270;

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final iconColor = _getIconColor(type, colors);
    final iconData = _getIcon(type);

    // Scroll: con el teclado abierto (sin resultados mientras se escribe) queda muy poco alto.
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.hasBoundedHeight ? constraints.maxHeight : 0),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(color: colors.surface, shape: BoxShape.circle),
                    child: Icon(iconData, size: 34, color: iconColor),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.75.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'PlayfairDisplay',
                      color: colors.ink,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: _messageMaxWidth),
                    child: Text(
                      message,
                      style: TextStyle(fontSize: 14.5.sp, fontWeight: FontWeight.w400, color: colors.ink2, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (actions.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Wrap(spacing: 10, runSpacing: 10, alignment: WrapAlignment.center, children: actions),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getIconColor(AppStateType type, AppColors colors) {
    switch (type) {
      case AppStateType.error:
        return colors.bad;
      case AppStateType.empty:
        return colors.ink2;
      case AppStateType.noResults:
        return colors.ink2;
    }
  }

  IconData _getIcon(AppStateType type) {
    switch (type) {
      case AppStateType.error:
        return Icons.cloud_off_rounded;
      case AppStateType.empty:
        return Icons.inventory_2_rounded;
      case AppStateType.noResults:
        return Icons.search_off_rounded;
    }
  }
}
