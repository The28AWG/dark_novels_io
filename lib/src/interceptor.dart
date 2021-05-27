import 'package:dark_novels_io/src/request.dart';
import 'package:dark_novels_io/src/response.dart';

/// Перехват запросов
abstract class Interceptor {
  /// конструктор
  const Interceptor();

  /// перехват
  Future<Request> onRequest(Request request) async => request;

  /// перехват
  Future<Response> onResponse(Response response) async => response;

  /// перехват
  void onError(dynamic error) async {}
}
