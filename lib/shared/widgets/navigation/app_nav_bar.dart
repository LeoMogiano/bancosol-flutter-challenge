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
  static const Duration _duration = Duration(milliseconds: 320);
  static const Curve _curve = Curves.easeOutCubic;
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
                      child: _Tabs(items: items, currentIndex: currentIndex, onTap: onTap),
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

class _Tabs extends StatelessWidget {
  const _Tabs({required this.items, required this.currentIndex, required this.onTap});

  static const int _activeFlex = 5;
  static const int _idleFlex = 3;

  final List<AppNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final duration = MediaQuery.disableAnimationsOf(context) ? Duration.zero : AppNavBar._duration;

    return LayoutBuilder(
      builder: (_, constraints) {
        final unit = constraints.maxWidth / (items.length * _idleFlex + _activeFlex - _idleFlex);
        return Stack(
          children: [
            AnimatedPositioned(
              duration: duration,
              curve: AppNavBar._curve,
              left: unit * _idleFlex * currentIndex,
              top: 0,
              bottom: 0,
              width: unit * _activeFlex,
              child: DecoratedBox(
                decoration: BoxDecoration(color: colors.navActive, borderRadius: BorderRadius.circular(26)),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var index = 0; index < items.length; index++)
                  AnimatedContainer(
                    duration: duration,
                    curve: AppNavBar._curve,
                    width: unit * (index == currentIndex ? _activeFlex : _idleFlex),
                    child: _Tab(
                      item: items[index],
                      isActive: index == currentIndex,
                      duration: duration,
                      onTap: () => onTap(index),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.item, required this.isActive, required this.duration, required this.onTap});

  final AppNavItem item;
  final bool isActive;
  final Duration duration;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: duration,
                child: Icon(
                  isActive ? item.activeIcon : item.icon,
                  key: ValueKey(isActive),
                  size: 23,
                  color: isActive ? colors.ink : colors.ink2,
                ),
              ),
              Flexible(
                child: AnimatedSwitcher(
                  duration: duration,
                  switchInCurve: AppNavBar._curve,
                  switchOutCurve: AppNavBar._curve,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SizeTransition(sizeFactor: animation, axis: Axis.horizontal, child: child),
                  ),
                  child: isActive
                      ? Padding(
                          key: const ValueKey(true),
                          padding: const EdgeInsets.only(left: 7),
                          child: Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: colors.ink),
                          ),
                        )
                      : const SizedBox.shrink(key: ValueKey(false)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
