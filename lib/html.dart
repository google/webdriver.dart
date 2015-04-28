library webdriver.html;

import 'dart:async' show Future;
import 'dart:convert' show JSON, UTF8;
import 'dart:html' show HttpRequest, ProgressEvent;

import 'package:webdriver/async_helpers.dart' show Lock;
import 'package:webdriver/core.dart' as core
    show createDriver, fromExistingSession, WebDriver;
import 'package:webdriver/src/command_processor.dart' show CommandProcessor;
import 'package:webdriver/src/exception.dart' show WebDriverException;

export 'package:webdriver/core.dart' hide createDriver, fromExistingSession;

final Uri defaultUri = Uri.parse('http://127.0.0.1:4444/wd/hub/');

/// Creates a WebDriver instance connected to the specified WebDriver server.
///
/// Note: WebDriver endpoints will be constructed using [resolve] against
/// [uri]. Therefore, if [uri] does not end with a trailing slash, the
/// last path component will be dropped.
Future<core.WebDriver> createDriver({Uri uri, Map<String, dynamic> desired}) =>
    core.createDriver(new _HtmlCommandProcessor(), uri: uri, desired: desired);

/// Creates a WebDriver instance connected to an existing session.
///
/// Note: WebDriver endpoints will be constructed using [resolve] against
/// [uri]. Therefore, if [uri] does not end with a trailing slash, the
/// last path component will be dropped.
Future<core.WebDriver> fromExistingSession(String sessionId, {Uri uri}) =>
    core.fromExistingSession(new _HtmlCommandProcessor(), sessionId, uri: uri);

class _HtmlCommandProcessor implements CommandProcessor {
  final Lock _lock = new Lock();

  @override
  Future<Object> post(Uri uri, dynamic params, {bool value: true}) =>
      _request('POST', uri, params, value);

  @override
  Future<Object> get(Uri uri, {bool value: true}) =>
      _request('GET', uri, null, value);

  @override
  Future<Object> delete(Uri uri, {bool value: true}) =>
      _request('DELETE', uri, null, value);

  @override
  Future close() async {}

  Future<Object> _request(
      String method, Uri uri, dynamic params, bool value) async {
    await _lock.acquire();
    var sendData = null;
    if (params != null && method == 'POST') {
      sendData = JSON.encode(params);
    }

    HttpRequest request;
    try {
      request = await HttpRequest.request(uri.toString(),
          method: method,
          requestHeaders: _headers,
          responseType: 'json',
          sendData: sendData,
          mimeType: 'application/json');
    } on ProgressEvent catch (e) {
      request = e.target;
    } finally {
      _lock.release();
    }
    var respBody = request.response;
    try {
      respBody = JSON.decode(respBody);
    } catch (e) {}

    if (request.status < 200 ||
        request.status > 299 ||
        (respBody is Map && respBody['status'] != 0)) {
      throw new WebDriverException(
          httpStatusCode: request.status,
          httpReasonPhrase: request.statusText,
          jsonResp: respBody);
    }
    if (value && respBody is Map) {
      return respBody['value'];
    }
    return respBody;
  }

  Map<String, String> get _headers => {'Accept': 'application/json',};
}
