import 'package:warehouse/core/storage/keys/store_box.dart';

// Los ids son los nombres en disco: renombrarlos invalida lo ya guardado.
abstract interface class StoreKey {
  StoreBox get box;

  String get id;
}
