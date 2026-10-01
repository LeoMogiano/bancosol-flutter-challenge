import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:warehouse/core/services/haptic_service.dart';
import 'package:warehouse/core/theme/app_dimens.dart';
import 'package:warehouse/core/theme/theme_context.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    required this.body,
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
    this.safeArea = true,
    this.scrollable = false,
    this.onRefresh,
    this.scrollController,
    this.bottomBar,
    this.navigationBarColor = Colors.transparent,
  });

  final Widget body;
  final EdgeInsetsGeometry padding;
  final bool safeArea;
  final bool scrollable;
  final RefreshCallback? onRefresh;
  final ScrollController? scrollController;
  final Widget? bottomBar;
  final Color navigationBarColor;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final statusBarIconBrightness = isDark ? Brightness.light : Brightness.dark;
    final navBarIconBrightness = isDark ? Brightness.light : Brightness.dark;

    var content = body;
    if (scrollable) {
      content = SingleChildScrollView(
        controller: scrollController,
        clipBehavior: .none,
        physics: onRefresh != null ? const AlwaysScrollableScrollPhysics() : null,
        child: content,
      );
    }
    if (onRefresh != null) {
      final refresh = onRefresh!;
      content = RefreshIndicator(
        color: context.colors.accent,
        onRefresh: () {
          HapticService.refresh();
          return refresh();
        },
        child: content,
      );
    }
    if (safeArea) content = SafeArea(child: content);
    content = Padding(padding: padding, child: content);
    content = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      excludeFromSemantics: true,
      child: content,
    );

    // AnnotatedRegion y no un AppBar vacío: en Material 3 el AppBar se tiñe al pasar contenido por debajo.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: statusBarIconBrightness,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: navigationBarColor,
        systemNavigationBarDividerColor: Colors.transparent,
        // Sin esto Android 10+ pinta un scrim oscuro sobre la nav bar de 3 botones.
        systemNavigationBarContrastEnforced: false,
        systemNavigationBarIconBrightness: navBarIconBrightness,
      ),
      child: Scaffold(backgroundColor: context.colors.bg, body: content, bottomNavigationBar: bottomBar),
    );
  }
}
