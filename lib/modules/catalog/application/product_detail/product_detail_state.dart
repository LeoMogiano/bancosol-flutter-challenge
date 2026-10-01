part of 'product_detail_bloc.dart';

class ProductDetailState extends Equatable {
  const ProductDetailState({this.sharing = false, this.shareError, this.confirmedShares = 0});

  final bool sharing;
  final Failure? shareError;

  // Contador: cada confirmación de la plataforma dispara un toast, aunque se comparta dos veces seguidas.
  final int confirmedShares;

  ProductDetailState copyWith({bool? sharing, Failure? Function()? shareError, int? confirmedShares}) {
    return ProductDetailState(
      sharing: sharing ?? this.sharing,
      shareError: shareError != null ? shareError() : this.shareError,
      confirmedShares: confirmedShares ?? this.confirmedShares,
    );
  }

  @override
  List<Object?> get props => [sharing, shareError, confirmedShares];
}
