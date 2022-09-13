import 'package:dark_novels_io/io.dart';
import 'package:http/http.dart' as http;

/// Вспомогательный класс
class Response {
  ///
  final DarkIO io;

  ///
  final BaseRequest request;

  ///
  final http.Response rawResponse;

  ///
  const Response(
    this.io,
    this.request,
    this.rawResponse,
  );
}
