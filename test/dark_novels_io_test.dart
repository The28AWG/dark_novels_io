// import 'package:flutter_test/flutter_test.dart';
import 'package:dark_novels_io/io.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('I must failed', () async {
    Response response = await (DarkIO.url('https://httpbin.org')
            .newRequest('/post')
          // DarkIO.url('https://api.dark-novels.ru').newRequest('/v2/chapter/')
          // DarkIO(
          //   http.Client(),
          //   Uri.parse('http://api.localhost'),
          //   [
          //     // UserAgentInterceptor(),
          //     TokenInterceptor(),
          //   ],
          // ).newRequest('/v2/chapter/')
          ..model = _toMap('s', 3)
          ..post())
        .execute();
    debugResponse(response);
  });
}

Map<String, dynamic> _toMap(
  String key,
  dynamic value,
) {
  Map<String, dynamic> t = {};
  t[key] = value;
  return t;
}

class GetChapter {
  final int chapterId;
  final int bookId;
  final String? format;
  final String? theme;

  GetChapter({
    required this.chapterId,
    required this.bookId,
    this.format,
    this.theme,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'c[]': chapterId,
        'b': this.bookId,
        'f': this.format,
        't': this.theme,
      };
}

void debugResponse(Response response) => print(
    '${response.rawResponse.request?.method} ${response.rawResponse.request?.url.toString()}\n'
    'status: ${response.rawResponse.statusCode}\n'
    'contentLength: ${response.rawResponse.contentLength}\n'
    'isRedirect: ${response.rawResponse.isRedirect}\n'
    'reasonPhrase: ${response.rawResponse.reasonPhrase}\n'
    'persistentConnection: ${response.rawResponse.persistentConnection}\n'
    'headers: ${response.rawResponse.headers}\n'
    'headers: ${response.rawResponse.request?.headers}\n'
    '${response.rawResponse.body}');
