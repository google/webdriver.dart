import 'dart:io' show ContentType, HttpHeaders;

import 'package:sync_http/sync_http.dart';

import '../common/request.dart';
import '../common/request_client.dart';

/// Sync request client using sync_http package.
class SyncHttpRequestClient extends SyncRequestClient {
  final Map<String, String> _headers;
  SyncHttpRequestClient(super.prefix, {Map<String, String> headers = const {}})
      : _headers = headers;

  @override
  WebDriverResponse sendRaw(WebDriverRequest request) {
    final requestUri = resolve(request.uri!);
    final SyncHttpClientRequest httpRequest;
    switch (request.method!) {
      case HttpMethod.httpGet:
        httpRequest = SyncHttpClient.getUrl(requestUri);
      case HttpMethod.httpPost:
        httpRequest = SyncHttpClient.postUrl(requestUri);
        httpRequest.headers.contentType =
            ContentType('application', 'json', charset: 'utf-8');
        httpRequest.write(request.body);
      case HttpMethod.httpDelete:
        httpRequest = SyncHttpClient.deleteUrl(requestUri);
    }

    _headers.forEach(httpRequest.headers.add);
    httpRequest.headers.add(HttpHeaders.acceptHeader, 'application/json');
    httpRequest.headers.add(HttpHeaders.cacheControlHeader, 'no-cache');

    final httpResponse = httpRequest.close();

    return WebDriverResponse(
        httpResponse.statusCode, httpResponse.reasonPhrase, httpResponse.body);
  }

  @override
  String toString() => 'SyncHttp';
}
