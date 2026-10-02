import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/modules/catalog/domain/entities/currency.dart';
import 'package:warehouse/modules/catalog/domain/entities/product_draft.dart';
import 'package:warehouse/modules/catalog/domain/repositories/product_repository.dart';
import 'package:warehouse/modules/catalog/domain/usecases/create_product_use_case.dart';

class _MockProductRepository extends Mock implements ProductRepository;

void main() {
  test('CreateProductUseCase valida el draft antes de tocar la red', () async {
    final repository = _MockProductRepository();
    final useCase = CreateProductUseCase(repository);
    const draft = ProductDraft(id: 1, sku: 'SKU-001', name: 'Mouse', price: 0, currency: Currency.bob, stock: 5);

    expect(() => useCase(draft), throwsA(isA<Failure>().having((f) => f.type, 'type', FailureType.validation)));
    verifyNever(() => repository.createProduct(draft));
  });
}
