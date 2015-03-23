library webdriver.html;

import 'dart:async' show Future;
import 'dart:collection' show UnmodifiableMapView;
import 'dart:convert' show JSON, UTF8;
import 'dart:html' show HttpRequest, ProgressEvent;

import 'package:webdriver/async_helpers.dart' show Lock;
import 'package:webdriver/core.dart' show WebDriver, Capabilities;
import 'package:webdriver/src/command_processor.dart' show CommandProcessor;
import 'package:webdriver/src/exception.dart' show WebDriverException;

export 'package:webdriver/core.dart';

final Uri defaultUri = Uri.parse('http://127.0.0.1:4444/wd/hub/');

/// Creates a WebDriver instance connected to the specified WebDriver server.
Future<WebDriver> createDriver({Uri uri, Map<String, dynamic> desired}) async {
  if (uri == null) {
    uri = defaultUri;
  }

  var commandProcessor = new _HtmlCommandProcessor();

  if (desired == null) {
    desired = Capabilities.empty;
  }

  var response = await commandProcessor.post(
      uri.resolve('session'), {'desiredCapabilities': desired}, value: false);
  return new WebDriver(commandProcessor, uri, response['sessionId'],
      new UnmodifiableMapView(response['value']));
}

class _HtmlCommandProcessor implements CommandProcessor {
  Lock _lock = new Lock();

  Future<Object> post(Uri uri, dynamic params, {bool value: true}) =>
      _request('POST', uri, params, value);

  Future<Object> get(Uri uri, {bool value: true}) =>
      _request('GET', uri, null, value);

  Future<Object> delete(Uri uri, {bool value: true}) =>
      _request('DELETE', uri, null, value);

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
