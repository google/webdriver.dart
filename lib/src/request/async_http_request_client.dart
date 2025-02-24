import 'dart:async';
import 'dart:convert' show utf8;

import 'package:http/http.dart' as http;

import '../../support/async.dart';

import '../common/request.dart';
import '../common/request_client.dart';

/// Async request client using the
/// specified or default [http.Client] from `package:http`.
class AsyncHttpRequestClient extends AsyncRequestClient {
  final Lock _lock = Lock();
  final Map<String, String> _headers;
  final http.Client _httpClient;

  AsyncHttpRequestClient(
    super.prefix, {
    Map<String, String> headers = const {},
    http.Client? httpClient,
  })  : _headers = headers,
        _httpClient = httpClient ?? http.Client();

  @override
  Future<WebDriverResponse> sendRaw(WebDriverRequest request) async {
    await _lock.acquire();

    try {
      final requestUri = resolve(request.uri!);
      final httpRequest = http.Request(request.method!.name, requestUri)
        ..followRedirects = true
        ..headers.addAll(_headers)
        ..headers.addAll({
          'Accept': 'application/json',
          'Accept-Charset': utf8.name,
          'Cache-Control': 'no-cache',
        });

      final requestBody = request.body;
      if (requestBody != null && requestBody.isNotEmpty) {
        httpRequest
          ..headers['Content-Type'] = 'application/json'
          ..bodyBytes = utf8.encode(requestBody);
      }

      final response = await _httpClient.send(httpRequest);
      return WebDriverResponse(
        response.statusCode,
        response.reasonPhrase,
        await utf8.decodeStream(response.stream),
      );
    } finally {
      _lock.release();
    }
  }

  @override
  String toString() => 'AsyncHttp';
}
