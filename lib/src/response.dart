import 'package:dark_novels_io/io.dart';
import 'package:dark_novels_io/src/request.dart';
import 'package:http/http.dart' as http;

/// Вспомогательный класс
class Response {
  ///
  final DarkIO _io;

  ///
  final Request _request;

  ///
  final http.Response _rawResponse;

  ///
  const Response(
    io,
    request,
    rawResponse,
  )   : this._io = io,
        this._request = request,
        this._rawResponse = rawResponse;

  ///
  DarkIO get io => this._io;

  ///
  Request get request => this._request;

  ///
  http.Response get rawResponse => this._rawResponse;
}
