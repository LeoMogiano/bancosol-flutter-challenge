import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:warehouse/app/router/app_routes.dart';
import 'package:warehouse/modules/catalog/application/products/products_bloc.dart';
import 'package:warehouse/modules/catalog/domain/usecases/get_products_use_case.dart';
import 'package:warehouse/modules/catalog/presentation/screens/product_detail_screen.dart';

class _MockGetProducts extends Mock implements GetProductsUseCase;

void main() {
  testWidgets('abierto por deep link sin historial, al cerrarse vuelve a Productos en vez de dejar el stack vacío', (
    tester,
  ) async {
    final bloc = ProductsBloc(getProducts: _MockGetProducts(), useCache: () => true);
    addTearDown(bloc.close);
    final router = GoRouter(
      initialLocation: AppRoutes.productDetail('no-existe'),
      routes: [
        GoRoute(path: AppRoutes.products, builder: (_, _) => const Text('listado')),
        GoRoute(
          path: '/products/:id',
          builder: (_, state) => ProductDetailScreen(remoteId: state.pathParameters['id']!),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      BlocProvider.value(
        value: bloc,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('listado'), findsOneWidget);
  });
}
