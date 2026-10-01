import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/services/haptic_service.dart';
import 'package:warehouse/core/theme/app_dimens.dart';
import 'package:warehouse/core/theme/app_fonts.dart';
import 'package:warehouse/core/theme/theme_context.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({required this.child, super.key});

  final Widget child;

  static Future<T?> show<T>(BuildContext context, Widget child) {
    HapticService.selection();
    return showModalBottomSheet<T>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: context.colors.scrim,
      sheetAnimationStyle: AppMotion.sheet,
      builder: (_) => CustomBottomSheet(child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.88),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _Handle(),
                Flexible(
                  child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(22, 4, 22, 16), child: child),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Handle extends StatelessWidget {
  const _Handle();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(color: colors.line, borderRadius: BorderRadius.circular(2)),
      ),
    );
  }
}

class SheetHeader extends StatelessWidget {
  const SheetHeader({required this.title, this.subtitle, super.key});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 19.65.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: AppFont.playfairDisplay.family,
                  color: colors.ink,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: colors.ink2),
                ),
              ],
            ],
          ),
        ),
        Tooltip(
          message: MaterialLocalizations.of(context).closeButtonTooltip,
          child: SizedBox(
            width: 36,
            height: 36,
            child: Material(
              color: colors.bg,
              borderRadius: BorderRadius.circular(50),
              child: InkWell(
                onTap: () => Navigator.of(context).maybePop(),
                borderRadius: BorderRadius.circular(50),
                child: Icon(Icons.close_rounded, size: 18, color: colors.ink),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SheetActions extends StatelessWidget {
  const SheetActions({required this.secondary, required this.primary, super.key});

  final Widget secondary;
  final Widget primary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 10, child: secondary),
        const SizedBox(width: 10),
        Expanded(flex: 13, child: primary),
      ],
    );
  }
}
