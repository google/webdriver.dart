import 'dart:async';
import 'dart:convert';
import 'dart:io' show ContentType, HttpClient, HttpHeaders;

import '../../support/async.dart';
import '../common/request.dart';
import '../common/request_client.dart';

/// Async request client using dart:io package.
class AsyncIoRequestClient extends AsyncRequestClient {
  final HttpClient client = HttpClient();
  final Map<String, String> _headers;

  final Lock _lock = Lock();

  AsyncIoRequestClient(super.prefix, {Map<String, String> headers = const {}})
      : _headers = headers;

  @override
  Future<WebDriverResponse> sendRaw(WebDriverRequest request) async {
    await _lock.acquire();

    final requestUri = resolve(request.uri!);
    final httpRequest = switch (request.method!) {
      HttpMethod.httpGet => await client.getUrl(requestUri),
      HttpMethod.httpPost => await client.postUrl(requestUri),
      HttpMethod.httpDelete => await client.deleteUrl(requestUri)
    };

    httpRequest.followRedirects = true;
    _headers.forEach(httpRequest.headers.add);
    httpRequest.headers.add(HttpHeaders.acceptHeader, 'application/json');
    httpRequest.headers.add(HttpHeaders.acceptCharsetHeader, utf8.name);
    httpRequest.headers.add(HttpHeaders.cacheControlHeader, 'no-cache');

    if (request.body != null && request.body!.isNotEmpty) {
      httpRequest.headers.contentType =
          ContentType('application', 'json', charset: 'utf-8');
      final body = utf8.encode(request.body!);
      httpRequest.contentLength = body.length;
      httpRequest.add(body);
    }

    try {
      final response = await httpRequest.close();

      return WebDriverResponse(response.statusCode, response.reasonPhrase,
          await utf8.decodeStream(response));
    } finally {
      _lock.release();
    }
  }

  @override
  String toString() => 'AsyncIo';

  @override
  void close() => client.close(force: true);
}
