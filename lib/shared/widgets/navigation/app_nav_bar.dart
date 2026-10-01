import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/shared/widgets/buttons/app_icon_button.dart';

class AppNavItem {
  const AppNavItem({required this.icon, required this.activeIcon, required this.label});

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

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

  static const double _margin = 24;
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
    // En iOS el inset ya separa la barra del home indicator; sumarle el margen la deja flotando alta.
    final bottom = defaultTargetPlatform == TargetPlatform.iOS ? math.max(_minBottom, inset) : _margin + inset;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottom),
      child: Row(
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(33), boxShadow: [_shadow]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(33),
                child: RepaintBoundary(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      height: 66,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: colors.nav,
                        borderRadius: BorderRadius.circular(33),
                        border: Border.all(color: colors.line),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(items.length, (index) {
                          final item = items[index];
                          final isActive = index == currentIndex;

                          return Expanded(
                            flex: isActive ? 5 : 3,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => onTap(index),
                                borderRadius: BorderRadius.circular(26),
                                child: Container(
                                  decoration: isActive
                                      ? BoxDecoration(color: colors.navActive, borderRadius: BorderRadius.circular(26))
                                      : null,
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        isActive ? item.activeIcon : item.icon,
                                        size: 23,
                                        color: isActive ? colors.ink : colors.ink2,
                                      ),
                                      if (isActive) ...[
                                        const SizedBox(width: 7),
                                        Flexible(
                                          child: Text(
                                            item.label,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w600,
                                              color: colors.ink,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
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
