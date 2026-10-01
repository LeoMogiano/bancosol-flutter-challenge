import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/core/di/service_locator.dart';
import 'package:warehouse/modules/catalog/application/preferences/preferences_cubit.dart';

class StateProvider extends StatelessWidget {
  const StateProvider({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<PreferencesCubit>(create: (_) => sl<PreferencesCubit>())],
      child: child,
    );
  }
}
