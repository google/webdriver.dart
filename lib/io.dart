library webdriver.io;

import 'dart:async' show Future;
import 'dart:collection' show UnmodifiableMapView;
import 'dart:convert' show JSON, UTF8;
import 'dart:io'
    show
        ContentType,
        HttpClient,
        HttpClientRequest,
        HttpClientResponse,
        HttpHeaders;

import 'package:webdriver/async_helpers.dart' show Lock;
import 'package:webdriver/core.dart' show WebDriver, Capabilities;
import 'package:webdriver/src/command_processor.dart' show CommandProcessor;
import 'package:webdriver/src/exception.dart' show WebDriverException;

export 'package:webdriver/core.dart';

final Uri defaultUri = Uri.parse('http://127.0.0.1:4444/wd/hub/');

/// Creates a WebDriver instance connected to the specified WebDriver server.
///
/// Note: WebDriver endpoints will be constructed using [resolve] against
/// [uri]. Therefore, if [uri] does not end with a trailing slash, the
/// last path component will be dropped.
Future<WebDriver> createDriver({Uri uri, Map<String, dynamic> desired}) async {
  if (uri == null) {
    uri = defaultUri;
  }

  var commandProcessor = new _IOCommandProcessor();

  if (desired == null) {
    desired = Capabilities.empty;
  }

  var response = await commandProcessor.post(
      uri.resolve('session'), {'desiredCapabilities': desired}, value: false);
  return new WebDriver(commandProcessor, uri, response['sessionId'],
      new UnmodifiableMapView(response['value']));
}

Future<WebDriver> fromExistingSession(String sessionId, {Uri uri}) async {
  if (uri == null) {
    uri = defaultUri;
  }

  var commandProcessor = new _IOCommandProcessor();

  return new WebDriver(commandProcessor, uri, sessionId, const {});
}

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
