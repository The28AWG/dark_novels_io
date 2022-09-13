import 'package:dark_novels_io/io.dart';
import 'package:meta/meta.dart';

/// Вспомогательный класс
class Request {
  ///
  @protected
  final DarkIO io;

  /// ссылка
  final String url;

  /// метод
  HttpMethod method = HttpMethod.GET;

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
  Request(this.url, this.io);

  /// GET
  void get() => this.method = HttpMethod.GET;

  /// POST
  void post() => this.method = HttpMethod.POST;

  /// POST upload
  void upload() {
    this.method = HttpMethod.POST;
    if (this.headers['Accept'] != 'multipart/form-data') {
      this.headers['Accept'] = 'multipart/form-data';
    }
  }

  /// PUT
  void put() => this.method = HttpMethod.PUT;

  /// DELETE
  void delete() => this.method = HttpMethod.DELETE;

  ///
  Future<Response> execute() => io.execute(this);

  /// изменение параметров
  Request copyWith({
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

class _ImmutableRequest extends Request {
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
  }) : super(url, io);

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
}
