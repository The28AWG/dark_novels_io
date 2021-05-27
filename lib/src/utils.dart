/// http методы
enum HttpMethod {
  /// get
  GET,

  /// post
  POST,

  /// put
  PUT,

  /// delete
  DELETE,
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
      query.forEach((element) {
        queryParameters.addAll(_fillQuery(element));
      });
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
