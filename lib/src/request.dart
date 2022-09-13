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

  /// конструктор
  Request(this.url, this.io);

  /// конструктор
  Request._({
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
      Request._(
        io: io ?? this.io,
        method: method ?? this.method,
        url: url ?? this.url,
        headers: headers ?? this.headers,
        path: path ?? this.path,
        model: model ?? this.model,
        query: query ?? this.query,
        body: body ?? this.body,
        attribute: attribute ?? this.attribute,
        binary: binary ?? this.binary,
      );
}
