import 'package:dio/dio.dart';

// Reenviar por el MISMO Dio: uno nuevo pierde adaptador, baseUrl y pool.
abstract interface class ReplaysRequests {
  set replayClient(Dio dio);
}
