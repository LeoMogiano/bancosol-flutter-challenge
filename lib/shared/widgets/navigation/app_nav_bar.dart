import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/shared/widgets/buttons/app_icon_button.dart';
import 'package:warehouse/shared/widgets/navigation/app_nav_tabs.dart';

export 'package:warehouse/shared/widgets/navigation/app_nav_tabs.dart' show AppNavItem;

class AppNavBar extends StatelessWidget {
  const AppNavBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    required this.onSearch,
    super.key,
  });

  final List<AppNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onSearch;

  static const double _minBottom = 16;

  static final _shadow = BoxShadow(
    color: const Color(0xFF1E281E).withValues(alpha: 0.28),
    blurRadius: 30,
    offset: const Offset(0, 12),
    spreadRadius: -12,
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final inset = MediaQuery.paddingOf(context).bottom;
    // El inset ya separa la barra de la navegación del sistema; sumarle margen la deja flotando alta.
    final bottom = math.max(_minBottom, inset);

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottom),
      child: Row(
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(33), boxShadow: [_shadow]),
              child: Container(
                height: 66,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: colors.nav,
                  borderRadius: BorderRadius.circular(33),
                  border: Border.all(color: colors.line),
                ),
                child: AppNavTabs(items: items, currentIndex: currentIndex, onTap: onTap),
              ),
            ),
          ),
          const SizedBox(width: 10),
          DecoratedBox(
            decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [_shadow]),
            child: AppIconButton(
              icon: Icons.search_rounded,
              onPressed: onSearch,
              size: 66,
              color: colors.onAccent,
              background: colors.accent,
              tooltip: MaterialLocalizations.of(context).searchFieldLabel,
            ),
          ),
        ],
      ),
    );
  }
}
