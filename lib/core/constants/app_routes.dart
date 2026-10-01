abstract final class AppRoutes {
  static const String summary = '/summary';
  static const String products = '/products';
  static const String settings = '/settings';

  static const String productIdParam = 'id';
  static const String productDetailPattern = '$products/:$productIdParam';

  static String productDetail(String id) => '$products/$id';
}
