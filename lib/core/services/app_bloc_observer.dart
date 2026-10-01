import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:warehouse/core/services/logger_service.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase<Object?> bloc, Change<Object?> change) {
    LoggerService.d('${bloc.runtimeType} → ${change.nextState.runtimeType}', name: 'BLOC');
    super.onChange(bloc, change);
  }

  @override
  void onError(BlocBase<Object?> bloc, Object error, StackTrace stackTrace) {
    LoggerService.e('${bloc.runtimeType}', error: error, stackTrace: stackTrace);
    unawaited(Sentry.captureException(error, stackTrace: stackTrace));
    super.onError(bloc, error, stackTrace);
  }
}
