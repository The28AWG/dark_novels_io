import 'package:dark_novels_io/io.dart';
import 'package:dotenv/dotenv.dart' show load, env, isEveryDefined;

/// токен
class TokenInterceptor extends Interceptor {

  @override
  Future<Request> onRequest(Request request) async {
    load();
    Map<String, String> headers = {}..addAll(request.headers);
    if (isEveryDefined(['token'])) {
      headers['Token'] = env['token']!;
    }
    return super.onRequest(request.copyWith(
      headers: headers,
    ));
  }
}
