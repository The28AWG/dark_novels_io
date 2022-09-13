import 'package:dark_novels_io/io.dart';
import 'package:dotenv/dotenv.dart';

/// токен
class TokenInterceptor extends Interceptor {

  @override
  Future<Request> onRequest(Request request) async {
    var env = DotEnv(includePlatformEnvironment: true)
      ..load();
    Map<String, String> headers = {}..addAll(request.headers);
    if (env.isDefined('token')) {
      headers['Token'] = env['token']!;
    }
    return super.onRequest(request.copyWith(
      headers: headers,
    ));
  }
}
