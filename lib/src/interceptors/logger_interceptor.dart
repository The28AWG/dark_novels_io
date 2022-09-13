import 'package:dark_novels_io/io.dart';

/// логирование запросов
class LoggerInterceptor extends Interceptor {
  final Function(String) _log;

  /// коснтруктор
  LoggerInterceptor([this._log = print]);

  @override
  Future<BaseRequest> onRequest(BaseRequest request) async {
    switch (request.method) {
      case HttpMethod.get:
        _get(request);
        break;
      case HttpMethod.post:
        _post(request);
        break;
      case HttpMethod.put:
        _put(request);
        break;
      case HttpMethod.delete:
        _delete(request);
        break;
    }
    return request;
  }

  void _get(BaseRequest request) {
    _log('curl ${_headers(request)} "${request.url}"');
  }

  void _post(BaseRequest request) {
    if (request.headers['Accept'] == 'multipart/form-data') {
      _log('curl -X POST ${_headers(request)} "${request.url}"');
    } else {
      _log('curl ${_body(request)} ${_headers(request)}'
          ' -X POST "${request.url}"');
    }
  }

  void _put(BaseRequest request) {
    _log('curl ${_body(request)} ${_headers(request)}'
        ' -X PUT "${request.url}"');
  }

  void _delete(BaseRequest request) {
    _log('curl ${_headers(request)} -X DELETE "${request.url}"');
  }

  String _headers(BaseRequest request) => request.headers.entries
      .map((e) => '-H "${e.key}: ${e.value}"')
      .toList()
      .join(' ');

  String _body(BaseRequest request) => (request.body is Map)
      ? (request.body as Map)
          .entries
          .map((e) => '-F "${e.key}=${e.value}"')
          .toList()
          .join(' ')
      : '-d \'${request.body}\'';
}
