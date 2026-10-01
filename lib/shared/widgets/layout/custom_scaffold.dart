import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:warehouse/core/theme/app_dimens.dart';
import 'package:warehouse/core/theme/theme_context.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    required this.body,
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
    this.safeArea = true,
    this.scrollable = false,
    this.bottomBar,
  });

  final Widget body;
  final EdgeInsetsGeometry padding;
  final bool safeArea;
  final bool scrollable;
  final Widget? bottomBar;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final statusBarIconBrightness = isDark ? Brightness.light : Brightness.dark;
    final navBarIconBrightness = isDark ? Brightness.light : Brightness.dark;

    var content = body;
    if (scrollable) content = SingleChildScrollView(child: content);
    if (safeArea) content = SafeArea(child: content);
    content = Padding(padding: padding, child: content);
    content = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: content,
    );

    return Scaffold(
      backgroundColor: context.colors.bg,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: statusBarIconBrightness,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: navBarIconBrightness,
        ),
      ),
      body: content,
      bottomNavigationBar: bottomBar,
    );
  }
}
