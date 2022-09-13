import 'package:dark_novels_io/io.dart';
import 'package:meta/meta.dart';

abstract class BaseRequest {
  ///
  @protected
  final DarkIO io;

  /// ссылка
  final String url;

  /// метод
  HttpMethod method = HttpMethod.get;

  /// модель
  dynamic model;

  /// параметры запроса
  dynamic query;

  /// тело запроса
  dynamic body;

  /// бинарное сообщение
  bool binary = false;

  /// заголовки
  Map<String, String> headers = const {};

  /// замена пути
  Map<String, dynamic> path = const {};

  /// атрибуты
  Map<String, dynamic> attribute = const {};

  ///
  BaseRequest(this.url, this.io);

  /// GET
  void get();

  /// POST
  void post();

  /// POST upload
  void upload();

  /// PUT
  void put();

  /// DELETE
  void delete();

  ///
  Future<Response> execute();

  /// изменение параметров
  BaseRequest copyWith({
    io,
    method,
    url,
    headers,
    model,
    query,
    body,
    attribute,
    binary,
    path,
  });
}

/// Вспомогательный класс
class Request implements BaseRequest {
  ///
  @override
  @protected
  final DarkIO io;

  /// ссылка
  @override
  final String url;

  /// метод
  @override
  HttpMethod method = HttpMethod.get;

  /// модель
  @override
  dynamic model;

  /// параметры запроса
  @override
  dynamic query;

  /// тело запроса
  @override
  dynamic body;

  /// бинарное сообщение
  @override
  bool binary = false;

  /// заголовки
  @override
  Map<String, String> headers = const {};

  /// замена пути
  @override
  Map<String, dynamic> path = const {};

  /// атрибуты
  @override
  Map<String, dynamic> attribute = const {};

  ///
  Request(this.url, this.io);

  /// GET
  @override
  void get() => this.method = HttpMethod.get;

  /// POST
  @override
  void post() => this.method = HttpMethod.post;

  /// POST upload
  @override
  void upload() {
    this.method = HttpMethod.post;
    if (this.headers['Accept'] != 'multipart/form-data') {
      this.headers['Accept'] = 'multipart/form-data';
    }
  }

  /// PUT
  @override
  void put() => this.method = HttpMethod.put;

  /// DELETE
  @override
  void delete() => this.method = HttpMethod.delete;

  ///
  @override
  Future<Response> execute() => io.execute(this);

  /// изменение параметров
  @override
  BaseRequest copyWith({
    io,
    method,
    url,
    headers,
    model,
    query,
    body,
    attribute,
    binary,
    path,
  }) =>
      _ImmutableRequest._(
        io: io ?? this.io,
        method: method ?? this.method,
        url: url ?? this.url,
        headers: Map.unmodifiable(headers ?? this.headers),
        path: Map.unmodifiable(path ?? this.path),
        model: model ?? this.model,
        query: query ?? this.query,
        body: body ?? this.body,
        attribute: Map.unmodifiable(attribute ?? this.attribute),
        binary: binary ?? this.binary,
      );
}

class _ImmutableRequest implements BaseRequest {
  ///
  @override
  final DarkIO io;

  /// ссылка
  @override
  final String url;

  /// метод
  @override
  final HttpMethod method;

  /// модель
  @override
  final dynamic model;

  /// параметры запроса
  @override
  final dynamic query;

  /// тело запроса
  @override
  final dynamic body;

  /// бинарное сообщение
  @override
  final bool binary;

  /// заголовки
  @override
  final Map<String, String> headers;

  /// замена пути
  @override
  final Map<String, dynamic> path;

  /// тип
  @override
  final Map<String, dynamic> attribute;

  /// конструктор
  _ImmutableRequest._({
    required this.io,
    required this.method,
    required this.url,
    required this.headers,
    required this.path,
    this.model,
    this.query,
    this.body,
    required this.attribute,
    this.binary = false,
  });

  /// GET
  @override
  void get() => throw UnsupportedError('immutable request');

  /// POST
  @override
  void post() => throw UnsupportedError('immutable request');

  /// POST upload
  @override
  void upload() => throw UnsupportedError('immutable request');

  /// PUT
  @override
  void put() => throw UnsupportedError('immutable request');

  /// DELETE
  @override
  void delete() => throw UnsupportedError('immutable request');

  ///
  @override
  Future<Response> execute() => throw UnsupportedError('immutable request');

  @override
  set attribute(Map<String, dynamic> attribute) {
    throw UnsupportedError('immutable request');
  }

  @override
  set binary(bool binary) {
    throw UnsupportedError('immutable request');
  }

  @override
  set body(body) {
    throw UnsupportedError('immutable request');
  }

  @override
  BaseRequest copyWith({
    io,
    method,
    url,
    headers,
    model,
    query,
    body,
    attribute,
    binary,
    path,
  }) {
    throw UnimplementedError();
  }

  @override
  set headers(Map<String, String> headers) {
    throw UnsupportedError('immutable request');
  }

  @override
  set method(HttpMethod method) {
    throw UnsupportedError('immutable request');
  }

  @override
  set model(model) {
    throw UnsupportedError('immutable request');
  }

  @override
  set path(Map<String, dynamic> path) {
    throw UnsupportedError('immutable request');
  }

  @override
  set query(query) {
    throw UnsupportedError('immutable request');
  }
}
