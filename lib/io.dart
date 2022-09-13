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
  final BaseRequest request;

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
      BaseRequest request,
  ) {
    switch (request.method) {
      case HttpMethod.get:
        return _endpoint(
          endpoint: endpoint,
          query: encodeQuery(request.query),
          path: request.path,
        );
      case HttpMethod.post:
        return _endpoint(
          endpoint: endpoint,
          path: request.path,
        );
      case HttpMethod.put:
        return _endpoint(
          endpoint: endpoint,
          path: request.path,
        );
      case HttpMethod.delete:
        return _endpoint(
          endpoint: endpoint,
          query: encodeQuery(request.query),
          path: request.path,
        );
    }
  }

  BaseRequest _bodyBuilder(
      BaseRequest request,
  ) {
    switch (request.method) {
      case HttpMethod.post:
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
      case HttpMethod.put:
        return request.copyWith(
          body: request.body ?? request.model == null
              ? encodeQuery(request.query)
              : jsonEncode(request.model),
        );
      default:
        return request;
    }
  }

  BaseRequest _headerBuilder(
      BaseRequest request,
  ) {
    Map<String, String> headers = {}..addAll(request.headers);
    if (!headers.containsKey('Accept')) {
      headers['Accept'] = 'application/json';
    }
    return request.copyWith(
      headers: headers,
    );
  }

  Future<RequestWrapper> _request(BaseRequest request) async {
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
    for (var part in parts) {
      endpoint = Node(part, endpoint);
    }
    switch (request.method) {
      case HttpMethod.get:
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
      case HttpMethod.post:
        if (request.headers['Accept'] == 'multipart/form-data') {
          _ApiMultipartRequest multipartRequest = _ApiMultipartRequest(
            _uriBuilder(
              endpoint!,
              request,
            ),
            this.client,
          );
          multipartRequest.fields.addAll(encodeQuery(request.query) ?? {});
          if (request.model is List<http.MultipartFile>) {
            multipartRequest.files.addAll(request.model);
          }
          if (request.model is http.MultipartFile) {
            multipartRequest.files.add(request.model);
          }
          Map<String, String> headers = {}..addAll(request.headers);
          headers.remove('Accept');
          multipartRequest.headers.addAll(headers);
          return http.Response.fromStream(await multipartRequest.send()).then(
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
      case HttpMethod.put:
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
      case HttpMethod.delete:
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
    Uri url,
    httpClient,
  )   : this._httpClient = httpClient,
        super('POST', url);

  @override
  Future<http.StreamedResponse> send() => this._httpClient.send(this);
}
