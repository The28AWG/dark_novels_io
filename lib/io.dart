library dark_novels_io;

import 'dart:async';
import 'dart:convert';

import 'package:dark_novels_io/src/interceptor.dart';
import 'package:dark_novels_io/src/node.dart';
import 'package:dark_novels_io/src/request.dart';
import 'package:dark_novels_io/src/response.dart';
import 'package:dark_novels_io/src/utils.dart';
import 'package:http/http.dart' as http;

export 'package:dark_novels_io/src/interceptor.dart';
export 'package:dark_novels_io/src/node.dart';
export 'package:dark_novels_io/src/request.dart';
export 'package:dark_novels_io/src/response.dart';
export 'package:dark_novels_io/src/utils.dart';

///
class RequestWrapper {
  ///
  final http.Response response;

  ///
  final Request request;

  ///
  RequestWrapper(this.response, this.request);
}

///
class DarkIO {
  ///
  final http.Client client;

  ///
  final Uri uri;

  ///
  final List<Interceptor> interceptors;

  ///
  DarkIO.url(
    String url,
  )   : this.client = http.Client(),
        this.uri = Uri.parse(url),
        this.interceptors = [];

  ///
  DarkIO(
    this.client,
    this.uri,
    this.interceptors,
  );

  Uri _endpoint({
    required Node endpoint,
    Map<String, dynamic /*String|Iterable<String>*/ >? query,
    required Map<String, dynamic /*String|Iterable<String>*/ > path,
  }) =>
      uri.replace(
        path: endpoint.get(path),
        queryParameters: query,
      );

  Future<Response> _response(
    Future<RequestWrapper> wrapper,
  ) {
    Future<Response> response = wrapper.then((value) => Response(
          this,
          value.request,
          value.response,
        ));
    for (Interceptor interceptor in interceptors) {
      response = response.then((value) => interceptor.onResponse(value));
    }
    return response;
  }

  Uri _uriBuilder(
    Node endpoint,
    Request request,
  ) {
    switch (request.method) {
      case HttpMethod.GET:
        return _endpoint(
          endpoint: endpoint,
          query: encodeQuery(request.query),
          path: request.path,
        );
      case HttpMethod.POST:
        return _endpoint(
          endpoint: endpoint,
          path: request.path,
        );
      case HttpMethod.PUT:
        return _endpoint(
          endpoint: endpoint,
          path: request.path,
        );
      case HttpMethod.DELETE:
        return _endpoint(
          endpoint: endpoint,
          query: encodeQuery(request.query),
          path: request.path,
        );
    }
  }

  Request _bodyBuilder(
    Request request,
  ) {
    switch (request.method) {
      case HttpMethod.POST:
        if (request.headers['Accept'] == 'multipart/form-data') {
          return request;
        }
        return request.copyWith(
          body: request.body ??
              (request.model == null
                  ? encodeQuery(request.query)
                  : request.binary
                      ? encodeQuery(request.query)
                      : jsonEncode(request.model)),
        );
      case HttpMethod.PUT:
        return request.copyWith(
          body: request.body ?? request.model == null
              ? encodeQuery(request.query)
              : jsonEncode(request.model),
        );
      default:
        return request;
    }
  }

  Request _headerBuilder(
    Request request,
  ) {
    Map<String, String> headers = {}..addAll(request.headers);
    if (!headers.containsKey('Accept')) {
      headers['Accept'] = 'application/json';
    }
    return request.copyWith(
      headers: headers,
    );
  }

  Future<RequestWrapper> _request(Request request) async {
    request = _headerBuilder(request);
    request = _bodyBuilder(request);
    for (Interceptor interceptor in interceptors) {
      request = await interceptor.onRequest(request);
    }
    String url = request.url;
    if (url.startsWith('/')) {
      url = url.substring(1);
    }
    List<String> parts = url.split('/');
    Node? endpoint;
    parts.forEach((part) => endpoint = Node(part, endpoint));
    switch (request.method) {
      case HttpMethod.GET:
        return this
            .client
            .get(
              _uriBuilder(
                endpoint!,
                request,
              ),
              headers: request.headers,
            )
            .then(
              (value) => RequestWrapper(
                value,
                request,
              ),
            );
      case HttpMethod.POST:
        if (request.headers['Accept'] == 'multipart/form-data') {
          _ApiMultipartRequest _request = _ApiMultipartRequest(
            'post',
            _uriBuilder(
              endpoint!,
              request,
            ),
            this.client,
          );
          _request.fields.addAll(encodeQuery(request.query) ?? {});
          if (request.model is List<http.MultipartFile>) {
            _request.files.addAll(request.model);
          }
          if (request.model is http.MultipartFile) {
            _request.files.add(request.model);
          }
          _request.headers.addAll(request.headers);
          return http.Response.fromStream(await _request.send()).then(
            (value) => RequestWrapper(
              value,
              request,
            ),
          );
        }
        return this
            .client
            .post(
              _uriBuilder(
                endpoint!,
                request,
              ),
              body: request.body,
              headers: request.headers,
            )
            .then(
              (value) => RequestWrapper(
                value,
                request,
              ),
            );
      case HttpMethod.PUT:
        return this
            .client
            .put(
              _uriBuilder(
                endpoint!,
                request,
              ),
              body: request.body,
              headers: request.headers,
            )
            .then(
              (value) => RequestWrapper(
                value,
                request,
              ),
            );
      case HttpMethod.DELETE:
        return this
            .client
            .delete(
              _uriBuilder(
                endpoint!,
                request,
              ),
              headers: request.headers,
              body: request.body,
            )
            .then(
              (value) => RequestWrapper(
                value,
                request,
              ),
            );
    }
  }

  ///
  Future<Response> execute(
    Request request,
  ) =>
      _response(
        _request(request),
      );

  ///
  Request newRequest(String url) => Request(
        url,
        this,
      );
}

class _ApiMultipartRequest extends http.MultipartRequest {
  final http.Client _httpClient;

  _ApiMultipartRequest(
    String method,
    Uri url,
    httpClient,
  )   : this._httpClient = httpClient,
        super(method, url);

  @override
  Future<http.StreamedResponse> send() => this._httpClient.send(this);
}
