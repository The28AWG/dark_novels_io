// import 'package:flutter_test/flutter_test.dart';
import 'package:dark_novels_io/io.dart';

void main() {
  // DarkIO.url('https://httpbin.org').newRequest('/post')
  DarkIO.url('https://api.dark-novels.ru').newRequest('/v2/chapter/')
    ..query = GetChapter(
      bookId: 514,
      chapterId: 345834,
      format: 'html'
    )
    ..upload()
    ..execute().then(debugResponse);
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
    '${response.rawResponse.body}');
