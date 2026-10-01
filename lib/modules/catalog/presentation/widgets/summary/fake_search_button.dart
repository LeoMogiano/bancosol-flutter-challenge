import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/modules/catalog/application/search_focus/search_focus_cubit.dart';

class FakeSearchButton extends StatelessWidget {
  const FakeSearchButton({required this.label, super.key});

  static const double _height = 52;

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.surface,
      shape: StadiumBorder(side: BorderSide(color: colors.line)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () {
          context.read<SearchFocusCubit>().request();
          StatefulNavigationShell.of(context).goBranch(1);
        },
        child: SizedBox(
          height: _height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              spacing: 10,
              children: [
                Icon(Icons.search_rounded, size: 22, color: colors.ink2),
                Text(
                  label,
                  style: TextStyle(fontSize: 15.sp, color: colors.ink3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
