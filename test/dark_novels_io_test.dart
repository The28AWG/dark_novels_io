// import 'package:flutter_test/flutter_test.dart';
import 'package:dark_novels_io/io.dart';

void main() {
  DarkIO.url('https://httpbin.org').newRequest('/post')
    ..query = {
      'a': 'w',
    }
    ..upload()
    ..execute().then(debugResponse);
}

void debugResponse(Response response) =>
    print('${response.rawResponse.request?.method} ${response.rawResponse.request?.url.toString()}\n'
        'status: ${response.rawResponse.statusCode}\n'
        'contentLength: ${response.rawResponse.contentLength}\n'
        'isRedirect: ${response.rawResponse.isRedirect}\n'
        'reasonPhrase: ${response.rawResponse.reasonPhrase}\n'
        'persistentConnection: ${response.rawResponse.persistentConnection}\n'
        'headers: ${response.rawResponse.headers}\n'
        '${response.rawResponse.body}');
