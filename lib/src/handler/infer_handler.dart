import 'dart:convert';

import 'package:webdriver/src/common/capabilities.dart';
import 'package:webdriver/src/common/exception.dart';
import 'package:webdriver/src/common/request.dart';
import 'package:webdriver/src/common/session.dart';
import 'package:webdriver/src/common/spec.dart';
import 'package:webdriver/src/common/webdriver_handler.dart';
import 'package:webdriver/src/handler/json_wire/session.dart';
import 'package:webdriver/src/handler/w3c/session.dart';

/// A [WebDriverHandler] that is only used when creating new session /
/// getting existing session info without given the spec.
class InferWebDriverHandler extends WebDriverHandler {
  @override
  final SessionHandler session = new InferSessionHandler();

  @override
  CoreHandler get core =>
      throw new UnsupportedError('Unsupported for InferHandler');

  @override
  ElementHandler get element =>
      throw new UnsupportedError('Unsupported for InferHandler');

  @override
  ElementFinder get elementFinder =>
      throw new UnsupportedError('Unsupported for InferHandler');

  @override
  KeyboardHandler get keyboard =>
      throw new UnsupportedError('Unsupported for InferHandler');

  @override
  MouseHandler get mouse =>
      throw new UnsupportedError('Unsupported for InferHandler');

  @override
  AlertHandler get alert =>
      throw new UnsupportedError('Unsupported for InferHandler');

  @override
  NavigationHandler get navigation =>
      throw new UnsupportedError('Unsupported for InferHandler');

  @override
  WindowHandler get window =>
      throw new UnsupportedError('Unsupported for InferHandler');

  @override
  FrameHandler get frame =>
      throw new UnsupportedError('Unsupported for InferHandler');

  @override
  CookiesHandler get cookies =>
      throw new UnsupportedError('Unsupported for InferHandler');

  @override
  TimeoutsHandler get timeouts =>
      throw new UnsupportedError('Unsupported for InferHandler');

  @override
  LogsHandler get logs =>
      throw new UnsupportedError('Unsupported for InferHandler');

  @override
  WebDriverRequest buildGeneralRequest(HttpMethod method, String uri,
          [params]) =>
      throw new UnsupportedError('Unsupported for InferHandler');

  @override
  dynamic parseGeneralResponse(
          WebDriverResponse response, dynamic Function(String) createElement) =>
      throw new UnsupportedError('Unsupported for InferHandler');
}

class InferSessionHandler extends SessionHandler {
  @override
  WebDriverRequest buildCreateRequest({Map<String, dynamic> desired}) =>
      new WebDriverRequest.postRequest('session', {
        'desiredCapabilities': desired,
        'capabilities': {'alwaysMatch': desired}
      });

  @override
  SessionInfo parseCreateResponse(WebDriverResponse response) {
    Map responseBody;
    try {
      responseBody = json.decode(response.body);
    } catch (e) {
      final rawBody = response.body == null || response.body.isEmpty
          ? '<empty response>'
          : response.body;
      throw new WebDriverException(
          response.statusCode, 'Error parsing response body: $rawBody');
    }

    // JSON responses have multiple keys.
    if (responseBody.keys.length > 1) {
      return new JsonWireSessionHandler().parseCreateResponse(response);
      // W3C responses have only one key, value.
    } else if (responseBody.keys.length == 1) {
      return new W3cSessionHandler().parseCreateResponse(response);
    }

    throw new WebDriverException(
        response.statusCode, 'Unexpected response structure: ${response.body}');
  }

  @override
  WebDriverRequest buildInfoRequest(String id) =>
      new WebDriverRequest.getRequest('session/$id');

  @override
  SessionInfo parseInfoResponse(WebDriverResponse response) {
    if (response.statusCode == 404) {
      // May be W3C, as it will throw an unknown command exception.
      Map body;
      try {
        body = json.decode(response.body)['value'];
      } catch (e) {
        final rawBody = response.body == null || response.body.isEmpty
            ? '<empty response>'
            : response.body;
        throw new WebDriverException(
            response.statusCode, 'Error parsing response body: $rawBody');
      }

      if (body == null ||
          body['error'] != 'unknown command' ||
          body['message'] is! String) {
        throw new WebDriverException(
            response.statusCode,
            'Unexpected response body (expecting `unexpected command error` '
            'produced by W3C WebDriver): ${response.body}');
      }

      final sessionId = new RegExp(r'/session/([0-9a-f-]*) ')
          .firstMatch(body['message'] as String)
          .group(1);
      return new SessionInfo(sessionId, WebDriverSpec.W3c, Capabilities.empty);
    }

    return new JsonWireSessionHandler().parseInfoResponse(response);
  }
}
