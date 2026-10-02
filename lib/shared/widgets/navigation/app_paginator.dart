import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/services/haptic_service.dart';
import 'package:warehouse/core/theme/theme_context.dart';

class AppPaginator extends StatelessWidget {
  const AppPaginator({
    required this.page,
    required this.pageCount,
    required this.onChanged,
    required this.pageLabel,
    super.key,
  });

  final int page;
  final int pageCount;
  final ValueChanged<int> onChanged;
  final String Function(int page) pageLabel;

  static const double _buttonSize = 36;
  static const double _buttonRadius = 20;
  static const double _gap = 8;

  void _go(int target) {
    if (target == page) return;
    HapticService.selection();
    onChanged(target);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final localizations = MaterialLocalizations.of(context);

    if (pageCount <= 1) return const SizedBox.shrink();

    final pages = _calculatePages();

    // FittedBox: con 5 números y 2 elipsis no cabe en teléfonos de 320–360 dp.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: _gap,
          children: [
            _NavigationButton(
              icon: Icons.chevron_left_rounded,
              tooltip: localizations.previousPageTooltip,
              onPressed: page > 1 ? () => _go(page - 1) : null,
              enabled: page > 1,
            ),
            ...pages.map((pageNum) {
              if (pageNum == -1) {
                return ExcludeSemantics(
                  child: Text(
                    '…',
                    style: TextStyle(fontSize: 14.5.sp, color: colors.ink2),
                  ),
                );
              }

              final isCurrentPage = pageNum == page;
              return Semantics(
                button: true,
                selected: isCurrentPage,
                excludeSemantics: true,
                label: pageLabel(pageNum),
                onTap: () => _go(pageNum),
                child: SizedBox(
                  width: _buttonSize,
                  height: _buttonSize,
                  child: Material(
                    color: isCurrentPage ? colors.accent : Colors.transparent,
                    borderRadius: BorderRadius.circular(_buttonRadius),
                    child: InkWell(
                      onTap: () => _go(pageNum),
                      borderRadius: BorderRadius.circular(_buttonRadius),
                      child: Container(
                        decoration: isCurrentPage
                            ? null
                            : BoxDecoration(
                                border: Border.all(color: colors.line),
                                borderRadius: BorderRadius.circular(_buttonRadius),
                              ),
                        child: Center(
                          child: Text(
                            pageNum.toString(),
                            style: TextStyle(
                              fontSize: 14.5.sp,
                              fontWeight: FontWeight.w600,
                              color: isCurrentPage ? colors.onAccent : colors.ink,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
            _NavigationButton(
              icon: Icons.chevron_right_rounded,
              tooltip: localizations.nextPageTooltip,
              onPressed: page < pageCount ? () => _go(page + 1) : null,
              enabled: page < pageCount,
            ),
          ],
        ),
      ),
    );
  }

  List<int> _calculatePages() {
    const maxVisible = 5;
    final pages = <int>[];

    if (pageCount <= maxVisible) {
      for (var i = 1; i <= pageCount; i++) {
        pages.add(i);
      }
    } else {
      pages.add(1);

      if (page <= 3) {
        for (var i = 2; i <= 4; i++) {
          pages.add(i);
        }
        pages.add(-1);
      } else if (page >= pageCount - 2) {
        pages.add(-1);
        for (var i = pageCount - 3; i < pageCount; i++) {
          pages.add(i);
        }
      } else {
        pages.addAll([-1, page - 1, page, page + 1, -1]);
      }

      pages.add(pageCount);
    }

    return pages;
  }
}

class _NavigationButton extends StatelessWidget {
  const _NavigationButton({required this.icon, required this.tooltip, required this.onPressed, required this.enabled});

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Material(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            onTap: enabled ? onPressed : null,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: colors.line),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Icon(icon, size: 20, color: colors.ink2.withValues(alpha: enabled ? 1 : 0.45)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
