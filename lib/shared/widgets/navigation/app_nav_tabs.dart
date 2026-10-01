import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/services/haptic_service.dart';
import 'package:warehouse/core/theme/theme_context.dart';

class AppNavItem {
  const AppNavItem({required this.icon, required this.activeIcon, required this.label});

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

class AppNavTabs extends StatelessWidget {
  const AppNavTabs({required this.items, required this.currentIndex, required this.onTap, super.key});

  static const Duration _duration = Duration(milliseconds: 320);
  static const Curve _curve = Curves.easeOutCubic;
  static const int _activeFlex = 5;
  static const int _idleFlex = 3;

  final List<AppNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final duration = MediaQuery.disableAnimationsOf(context) ? Duration.zero : AppNavTabs._duration;

    return LayoutBuilder(
      builder: (_, constraints) {
        final unit = constraints.maxWidth / (items.length * _idleFlex + _activeFlex - _idleFlex);
        return Stack(
          children: [
            AnimatedPositioned(
              duration: duration,
              curve: AppNavTabs._curve,
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
                    curve: AppNavTabs._curve,
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

class _Tab extends StatefulWidget {
  const _Tab({required this.item, required this.isActive, required this.duration, required this.onTap});

  final AppNavItem item;
  final bool isActive;
  final Duration duration;
  final VoidCallback onTap;

  @override
  State<_Tab> createState() => _TabState();
}

class _TabState extends State<_Tab> {
  static const Duration _pressDuration = Duration(milliseconds: 120);
  static const double _pressedScale = 0.92;

  bool _pressed = false;

  void _handleTap() {
    if (!widget.isActive) HapticService.selection();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final item = widget.item;
    final isActive = widget.isActive;
    final duration = widget.duration;

    // Sin ripple: la onda se deformaba al cambiar el ancho del tab; la respuesta es un leve encogimiento.
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleTap,
        onHighlightChanged: (pressed) => setState(() => _pressed = pressed),
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        borderRadius: BorderRadius.circular(26),
        child: AnimatedScale(
          scale: _pressed ? _pressedScale : 1,
          duration: duration == Duration.zero ? Duration.zero : _pressDuration,
          curve: Curves.easeOut,
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
                    switchInCurve: AppNavTabs._curve,
                    switchOutCurve: AppNavTabs._curve,
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SizeTransition(
                        sizeFactor: animation,
                        axis: Axis.horizontal,
                        alignment: AlignmentDirectional.centerStart,
                        child: child,
                      ),
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
      ),
    );
  }
}
