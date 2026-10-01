import 'package:flutter_bloc/flutter_bloc.dart';

// El estado es "pendiente" y no un evento: Productos puede no estar construido aún
// (IndexedStack crea las ramas al visitarlas) y debe consumirlo al montarse.
class SearchFocusCubit extends Cubit<bool> {
  SearchFocusCubit() : super(false);

  void request() => emit(true);

  void consumed() => emit(false);
}
