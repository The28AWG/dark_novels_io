import 'package:dark_novels_io/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('transform test', () {
    // http.Response rawResponse = http.Response('{"data":{"a": "test"}}', 200);
    // http.Response rawResponse = http.Response('{"data": "test", "message": "error text"}', 200);
    http.Response rawResponse = http.Response('{"status": "success", "data":{"a": "test"}}', 200);
    DarkIO io = DarkIO.url('url');
    Request request = Request('url', io);
    Response response = Response(io, request, rawResponse);
    debugPrint('transform: ${transform<String>(response, (data) {
      debugPrint('data: $data');
      debugPrint('data.runtimeType: ${data.runtimeType}');
      return data['a'];
    })}');
  });
}
