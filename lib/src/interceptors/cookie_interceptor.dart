import 'package:dark_novels_io/io.dart';

/// куки
class CookieInterceptor extends Interceptor {
  /// headers
  Map<String, String> headers = {};

  /// cookies
  Map<String, String> cookies = {};

  @override
  Future<Request> onRequest(Request request) {
    Map<String, String> headers = {}
      ..addAll(request.headers)
      ..addAll(this.headers);
    return super.onRequest(request.copyWith(
      headers: headers,
    ));
  }

  @override
  Future<Response> onResponse(Response response) {
    String? allSetCookie = response.rawResponse.headers['set-cookie'];

    if (allSetCookie != null) {
      List<String> setCookies = allSetCookie.split(',');
      for (String setCookie in setCookies) {
        List<String> cookies = setCookie.split(';');
        for (var cookie in cookies) {
          _setCookie(cookie);
        }
      }

      headers['cookie'] = _generateCookieHeader();
    }
    return super.onResponse(response);
  }

  void _setCookie(String rawCookie) {
    if (rawCookie.isNotEmpty) {
      List<String> keyValue = rawCookie.split('=');
      if (keyValue.length == 2) {
        String key = keyValue[0].trim();
        String value = keyValue[1];
        // ignore keys that aren't cookies
        if (key == 'path' || key == 'expires') return;
        this.cookies[key] = value;
      }
    }
  }

  String _generateCookieHeader() {
    String cookie = '';

    for (var key in cookies.keys) {
      if (cookie.isNotEmpty) cookie += ';';
      cookie += '$key=${cookies[key]}';
    }

    return cookie;
  }
}
