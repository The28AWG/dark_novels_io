import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dark_novels_io/io.dart';
import 'package:equatable/equatable.dart';

/// http методы
enum HttpMethod {
  /// get
  get,

  /// post
  post,

  /// put
  put,

  /// delete
  delete,
}

///
String encodeMap(Map data) {
  return data.keys
      .map((key) =>
          '${Uri.encodeComponent(key)}=${Uri.encodeComponent(data[key])}')
      .join('&');
}

///
Map<String, dynamic> _fillQuery(query) {
  Map<String, dynamic> queryParameters = {};
  if (query != null) {
    if (query is List) {
      for (var element in query) {
        queryParameters.addAll(_fillQuery(element));
      }
    } else if (query is Map) {
      queryParameters.addAll(query as Map<String, dynamic>);
    } else {
      queryParameters.addAll(query?.toJson());
    }
  }
  return queryParameters;
}

///
Map<String, String>? encodeQuery(query) {
  Map<String, dynamic> tmp = _fillQuery(query)
    ..removeWhere((key, value) => value == null);
  Map<String, String> q = tmp
      .map((key, value) => MapEntry(key, value.toString()))
    ..removeWhere((key, value) => value.isEmpty);
  return q.isEmpty ? null : q;
}

///
class ApiResponse extends Equatable {
  ///
  final String status;

  ///
  final String? message;

  ///
  final dynamic data;

  const ApiResponse._({required this.status, this.message, this.data});

  ///
  @override
  List<Object?> get props => [this.status, this.message, this.data];

  ///
  const ApiResponse.success({this.message, this.data})
      : this.status = 'success';

  ///
  const ApiResponse.error({this.message, this.data}) : this.status = 'error';

  ///
  const ApiResponse.binary(Uint8List this.data)
      : this.status = 'success',
        this.message = 'binary';

  ///
  factory ApiResponse.parse(
    Map<String, dynamic> json, [
    Function(dynamic)? map,
  ]) {
    String? status = json['status'];
    if (status == 'error' || status == null) {
      Map<String, dynamic> errors;
      if (json['data'] is Map<String, dynamic>) {
        errors = json['data'];
      } else {
        errors = {
          'error': json['data'],
        };
      }
      throw ApiException(json['message'], errors);
    }
    return ApiResponse._(
      status: status,
      message: json['message'],
      data: map?.call(json['data']) ?? json['data'],
    );
  }

  ///
  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);

  ///
  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
}

ApiResponse _$ApiResponseFromJson(Map<String, dynamic> json) {
  return ApiResponse._(
    status: json['status'] as String,
    message: json['message'] as String?,
    data: json['data'],
  );
}

Map<String, dynamic> _$ApiResponseToJson(ApiResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': _safeToJson(instance.data),
    };

dynamic _safeToJson(dynamic data) {
  try {
    return data?.toJson != null && data?.toJson is Function
        ? data?.toJson()
        : data is List
            ? data.map((e) => _safeToJson(e))
            : data;
  } on NoSuchMethodError catch (_) {
    return data;
  }
}

///
class ApiException implements Exception {
  ///
  final String? message;

  ///
  final Map<String, dynamic>? errors;

  ///
  const ApiException(this.message, [this.errors]);

  ///
  String report(String type) {
    String report = type;
    if (message != null && '' != message) {
      report = '$report: $message';
    }
    if (errors != null && errors!.isNotEmpty) {
      report = '$report. Errors: ${jsonEncode(errors)}';
    }
    return report;
  }

  @override
  String toString() {
    return report(runtimeType.toString());
  }
}

///
class SecurityException extends ApiException {
  ///
  SecurityException(message, [errors]) : super(message, errors);

  @override
  String toString() {
    return report(runtimeType.toString());
  }
}

///
class InternetException extends ApiException {
  ///
  SocketException exception;

  ///
  InternetException(this.exception) : super('internet exception', null);

  @override
  String toString() {
    return report(runtimeType.toString());
  }
}

///
T? transform<T extends Object>(
  Response value, [
  T Function(dynamic)? map,
]) {
  if (value.rawResponse.statusCode == 401) {
    Map<String, dynamic> json = jsonDecode(
      utf8.decode(
        value.rawResponse.bodyBytes,
      ),
    );
    SecurityException e = SecurityException(
      json['message'],
      json['data'],
    );
    for (Interceptor interceptor in value.io.interceptors) {
      interceptor.onError(e);
    }
    throw e;
  }
  return ApiResponse.parse(
    jsonDecode(
      utf8.decode(
        value.rawResponse.bodyBytes,
      ),
    ),
    map,
  ).data;
}
