// import 'package:flutter_test/flutter_test.dart';
import 'package:dark_novels_io/io.dart';
import 'package:dark_novels_io/src/response.dart';

Future<String> one() async => 'one';

void main() {
  // Request request = Request('/anything', DarkIO.url('https://httpbin.org'))
  //   ..body = ''
  //   ..post()
  //   ..execute().then((response) => print(response.rawResponse.body));

  DarkIO.url('https://httpbin.org').newRequest('/anything/zzz')
    ..headers = {
      'test': 'qwerty',
    }
    ..path = {
      'zzz': 'qqq',
    }
    ..query = {
      'a': 'w',
    }
    ..execute().then(debugResponse);
  DarkIO.url('https://httpbin.org').newRequest('/status/:code')
    ..headers = {
      'test': 'qwerty',
    }
    ..path = {
      ':code': '404',
    }
    ..query = {
      'a': 'w',
    }
    ..execute().then(debugResponse);
  DarkIO.url('http://178.129.43.1')
      .newRequest('/')
      .execute()
      .timeout(
    Duration(
      seconds: 1,
    ),
  )
      .then(debugResponse)
      .catchError((e) => print(e));
  DarkIO.url('')
      .newRequest('')
      .execute()
      .timeout(
    Duration(
      seconds: 1,
    ),
  )
      .then(debugResponse)
      .catchError((e) => print(e));
}

void debugResponse(Response response) =>
    print('status: ${response.rawResponse.statusCode}\n'
        'contentLength: ${response.rawResponse.contentLength}\n'
        'isRedirect: ${response.rawResponse.isRedirect}\n'
        'reasonPhrase: ${response.rawResponse.reasonPhrase}\n'
        'persistentConnection: ${response.rawResponse.persistentConnection}\n'
        'headers: ${response.rawResponse.headers}\n'
        '${response.rawResponse.body}');
