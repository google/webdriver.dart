import 'dart:async';
import 'dart:html';

import '../../support/async.dart';

import '../common/request.dart';
import '../common/request_client.dart';

/// Async request client using dart:html package.
///
/// On the low level, it's using XMLHttpRequest object (XHR).
class AsyncXhrRequestClient extends AsyncRequestClient {
  final Lock _lock = Lock();
  final Map<String, String> _headers;

  AsyncXhrRequestClient(super.prefix, {Map<String, String> headers = const {}})
      : _headers = headers;

  @override
  Future<WebDriverResponse> sendRaw(WebDriverRequest request) async {
    await _lock.acquire();

    final headers = {
      'Accept': 'application/json',
    };

    headers.addAll(_headers);
    if (request.body != null && request.body!.isNotEmpty) {
      headers['Content-Type'] ??= 'application/json';
    }

    HttpRequest httpRequest;

    try {
      httpRequest = await HttpRequest.request(resolve(request.uri!).toString(),
          method: request.method!.name,
          requestHeaders: headers,
          sendData: request.body,
          mimeType: 'application/json');
    } on ProgressEvent catch (e) {
      httpRequest = e.target as HttpRequest;
    } finally {
      _lock.release();
    }

    return WebDriverResponse(
      httpRequest.status,
      httpRequest.statusText,
      httpRequest.response as String?,
    );
  }

  @override
  String toString() => 'AsyncXhr';
}
