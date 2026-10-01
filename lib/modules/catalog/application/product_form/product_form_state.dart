part of 'product_form_cubit.dart';

class ProductFormState extends Equatable {
  const ProductFormState({
    this.sku = '',
    this.name = '',
    this.price = '',
    this.stock = '',
    this.currency = 'BOB',
    this.touched = const {},
    this.submitted = false,
    this.submitting = false,
    this.submitError,
    this.created,
  });

  final String sku;
  final String name;
  final String price;
  final String stock;
  final String currency;
  final Set<ProductField> touched;
  final bool submitted;
  final bool submitting;
  final Failure? submitError;
  final Product? created;

  ProductFormState copyWith({
    String? sku,
    String? name,
    String? price,
    String? stock,
    String? currency,
    Set<ProductField>? touched,
    bool? submitted,
    bool? submitting,
    Failure? Function()? submitError,
    Product? Function()? created,
  }) {
    return ProductFormState(
      sku: sku ?? this.sku,
      name: name ?? this.name,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      currency: currency ?? this.currency,
      touched: touched ?? this.touched,
      submitted: submitted ?? this.submitted,
      submitting: submitting ?? this.submitting,
      submitError: submitError != null ? submitError() : this.submitError,
      created: created != null ? created() : this.created,
    );
  }

  @override
  List<Object?> get props => [sku, name, price, stock, currency, touched, submitted, submitting, submitError, created];
}
