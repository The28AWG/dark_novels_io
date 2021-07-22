import 'dart:io';

import 'package:dark_novels_io/io.dart';
import 'package:flutter/foundation.dart';

/// токен
class UserAgentInterceptor extends Interceptor {
  final ValueNotifier<Version> _version;

  /// конструктор
  UserAgentInterceptor([version])
      : this._version = version ??
            ValueNotifier(
              Version(
                'Unknown',
                'Unknown',
              ),
            );

  @override
  Future<Request> onRequest(Request request) async {
    Map<String, String> headers = {}..addAll(request.headers);
    if (!kIsWeb) {
      headers['User-Agent'] =
          'novels/${_version.value.name}+${_version.value.number}'
          ' ${_getHttpVersion()} ${Platform.operatingSystem}/'
          '${Platform.operatingSystemVersion}';
    }
    return super.onRequest(request.copyWith(
      headers: headers,
    ));
  }

  String _getHttpVersion() {
    var version = Platform.version;
    // Only include major and minor version numbers.
    int index = version.indexOf('.', version.indexOf('.') + 1);
    version = version.substring(0, index);
    return 'Dart/$version (dart:io)';
  }
}

/// версия
class Version {
  /// название
  final String name;

  /// номер
  final String number;

  /// конструктор
  const Version(this.name, this.number);
}
