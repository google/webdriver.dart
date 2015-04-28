library webdriver.io;

import 'dart:async' show Future;
import 'dart:convert' show JSON, UTF8;
import 'dart:io'
    show
        ContentType,
        HttpClient,
        HttpClientRequest,
        HttpClientResponse,
        HttpHeaders;

import 'package:webdriver/async_helpers.dart' show Lock;
import 'package:webdriver/core.dart' as core
    show createDriver, fromExistingSession, WebDriver;
import 'package:webdriver/src/command_processor.dart' show CommandProcessor;
import 'package:webdriver/src/exception.dart' show WebDriverException;

export 'package:webdriver/core.dart' hide createDriver, fromExistingSession;

/// Creates a WebDriver instance connected to the specified WebDriver server.
///
/// Note: WebDriver endpoints will be constructed using [resolve] against
/// [uri]. Therefore, if [uri] does not end with a trailing slash, the
/// last path component will be dropped.
Future<core.WebDriver> createDriver({Uri uri, Map<String, dynamic> desired}) =>
    core.createDriver(new _IOCommandProcessor(), uri: uri, desired: desired);

/// Creates a WebDriver instance connected to an existing session.
///
/// Note: WebDriver endpoints will be constructed using [resolve] against
/// [uri]. Therefore, if [uri] does not end with a trailing slash, the
/// last path component will be dropped.
Future<core.WebDriver> fromExistingSession(String sessionId, {Uri uri}) =>
    core.fromExistingSession(new _IOCommandProcessor(), sessionId, uri: uri);

final ContentType _contentTypeJson =
    new ContentType("application", "json", charset: "utf-8");

class _IOCommandProcessor implements CommandProcessor {
  final HttpClient client = new HttpClient();

  final Lock _lock = new Lock();

  @override
  Future<Object> post(Uri uri, dynamic params, {bool value: true}) async {
    await _lock.acquire();
    HttpClientRequest request = await client.postUrl(uri);
    _setUpRequest(request);
    request.headers.contentType = _contentTypeJson;
    if (params != null) {
      var body = UTF8.encode(JSON.encode(params));
      request.contentLength = body.length;
      request.add(body);
    } else {
      request.contentLength = 0;
    }
    return await _processResponse(await request.close(), value);
  }

  @override
  Future<Object> get(Uri uri, {bool value: true}) async {
    await _lock.acquire();
    HttpClientRequest request = await client.getUrl(uri);
    _setUpRequest(request);
    return await _processResponse(await request.close(), value);
  }

  @override
  Future<Object> delete(Uri uri, {bool value: true}) async {
    await _lock.acquire();
    HttpClientRequest request = await client.deleteUrl(uri);
    _setUpRequest(request);
    return await _processResponse(await request.close(), value);
  }

  @override
  Future close() async {
    await client.close(force: true);
  }

  _processResponse(HttpClientResponse response, bool value) async {
    var respBody = await UTF8.decodeStream(response);
    _lock.release();
    try {
      respBody = JSON.decode(respBody);
    } catch (e) {}

    if (response.statusCode < 200 ||
        response.statusCode > 299 ||
        (respBody is Map && respBody['status'] != 0)) {
      throw new WebDriverException(
          httpStatusCode: response.statusCode,
          httpReasonPhrase: response.reasonPhrase,
          jsonResp: respBody);
    }
    if (value && respBody is Map) {
      return respBody['value'];
    }
    return respBody;
  }

  void _setUpRequest(HttpClientRequest request) {
    request.followRedirects = false;
    request.headers.add(HttpHeaders.ACCEPT, "application/json");
    request.headers.add(HttpHeaders.ACCEPT_CHARSET, UTF8.name);
    request.headers.add(HttpHeaders.CACHE_CONTROL, "no-cache");
  }
}
