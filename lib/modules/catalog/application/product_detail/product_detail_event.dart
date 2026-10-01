part of 'product_detail_bloc.dart';

sealed class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object?> get props => [];
}

final class ProductDetailShareRequested extends ProductDetailEvent {
  const ProductDetailShareRequested(this.product, {required this.text});

  final Product product;
  final String text;

  @override
  List<Object?> get props => [product, text];
}
