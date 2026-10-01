import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/core/di/service_locator.dart';
import 'package:warehouse/modules/catalog/application/preferences/preferences_cubit.dart';
import 'package:warehouse/modules/catalog/application/products/products_bloc.dart';

class StateProvider extends StatelessWidget {
  const StateProvider({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // .value: son singletons de get_it; el provider no debe cerrarlos.
        BlocProvider<PreferencesCubit>.value(value: sl<PreferencesCubit>()),
        BlocProvider<ProductsBloc>.value(value: sl<ProductsBloc>()),
      ],
      child: child,
    );
  }
}
