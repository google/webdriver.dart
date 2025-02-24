import 'dart:async';

import 'package:web/web.dart' as web;

import '../../support/async.dart';
import '../common/request.dart';
import '../common/request_client.dart';

/// Async request client using `dart:js_interop` through `package:web`.
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

    web.XMLHttpRequest httpRequest;
    try {
      // ignore: deprecated_member_use
      httpRequest = await web.HttpRequest.request(
        resolve(request.uri!).toString(),
        method: request.method!.name,
        requestHeaders: {
          ..._headers,
          'Accept': 'application/json',
          if (request.body?.isNotEmpty ?? false)
            'Content-Type': 'application/json',
        },
        sendData: request.body,
        mimeType: 'application/json',
      );
    } on web.ProgressEvent catch (e) {
      httpRequest = e.target as web.XMLHttpRequest;
    } finally {
      _lock.release();
    }

    return WebDriverResponse(
      httpRequest.status,
      httpRequest.statusText,
      httpRequest.responseText,
    );
  }

  @override
  String toString() => 'AsyncXhr';
}
