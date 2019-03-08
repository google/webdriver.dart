import 'dart:math';

import 'package:webdriver/src/common/request.dart';
import 'package:webdriver/src/common/webdriver_handler.dart';

import 'utils.dart';

class W3cElementHandler extends ElementHandler {
  @override
  WebDriverRequest buildClickRequest(String elementId) {
    return WebDriverRequest.postRequest('${elementPrefix(elementId)}click');
  }

  @override
  void parseClickResponse(WebDriverResponse response) {
    parseW3cResponse(response);
  }

  @override
  WebDriverRequest buildSendKeysRequest(String elementId, String keysToSend) {
    return WebDriverRequest.postRequest('${elementPrefix(elementId)}value', {
      'text': keysToSend, // What geckodriver really wants.
      'value': keysToSend // Actual W3C spec.
    });
  }

  @override
  void parseSendKeysResponse(WebDriverResponse response) {
    parseW3cResponse(response);
  }

  @override
  WebDriverRequest buildClearRequest(String elementId) {
    return WebDriverRequest.postRequest('${elementPrefix(elementId)}clear');
  }

  @override
  void parseClearResponse(WebDriverResponse response) {
    parseW3cResponse(response);
  }

  @override
  WebDriverRequest buildSelectedRequest(String elementId) {
    return WebDriverRequest.getRequest('${elementPrefix(elementId)}selected');
  }

  @override
  bool parseSelectedResponse(WebDriverResponse response) {
    return parseW3cResponse(response);
  }

  @override
  WebDriverRequest buildEnabledRequest(String elementId) {
    return WebDriverRequest.getRequest('${elementPrefix(elementId)}enabled');
  }

  @override
  bool parseEnabledResponse(WebDriverResponse response) {
    return parseW3cResponse(response);
  }

  @override
  WebDriverRequest buildDisplayedRequest(String elementId) {
    return buildCssPropertyRequest(elementId, 'display');
  }

  @override
  bool parseDisplayedResponse(WebDriverResponse response) {
    return parseCssPropertyResponse(response) != 'none';
  }

  @override
  WebDriverRequest buildLocationRequest(String elementId) {
    return _buildRectRequest(elementId);
  }

  @override
  Point<int> parseLocationResponse(WebDriverResponse response) {
    return _parseRectResponse(response).topLeft;
  }

  @override
  WebDriverRequest buildSizeRequest(String elementId) {
    return _buildRectRequest(elementId);
  }

  @override
  Rectangle<int> parseSizeResponse(WebDriverResponse response) {
    final rect = _parseRectResponse(response);
    return Rectangle(0, 0, rect.width, rect.height);
  }

  WebDriverRequest _buildRectRequest(String elementId) {
    return WebDriverRequest.getRequest('${elementPrefix(elementId)}rect');
  }

  Rectangle<int> _parseRectResponse(WebDriverResponse response) {
    final rect = parseW3cResponse(response);
    return Rectangle(rect['x'].toInt(), rect['y'].toInt(),
        rect['width'].toInt(), rect['height'].toInt());
  }

  @override
  WebDriverRequest buildNameRequest(String elementId) {
    return WebDriverRequest.getRequest('${elementPrefix(elementId)}name');
  }

  @override
  String parseNameResponse(WebDriverResponse response) {
    return parseW3cResponse(response);
  }

  @override
  WebDriverRequest buildTextRequest(String elementId) {
    return WebDriverRequest.getRequest('${elementPrefix(elementId)}text');
  }

  @override
  String parseTextResponse(WebDriverResponse response) {
    return parseW3cResponse(response);
  }

  @override
  WebDriverRequest buildAttributeRequest(String elementId, String name) {
    return WebDriverRequest.getRequest(
        '${elementPrefix(elementId)}attribute/$name');
  }

  @override
  String parseAttributeResponse(WebDriverResponse response) {
    return parseW3cResponse(response)?.toString();
  }

  @override
  @deprecated
  WebDriverRequest buildSeleniumAttributeRequest(
      String elementId, String name) {
    return WebDriverRequest.getRequest(
        '${elementPrefix(elementId)}attribute/$name');
  }

  @override
  @deprecated
  String parseSeleniumAttributeResponse(WebDriverResponse response) {
    return parseW3cResponse(response)?.toString();
  }

  @override
  WebDriverRequest buildCssPropertyRequest(String elementId, String name) {
    return WebDriverRequest.getRequest('${elementPrefix(elementId)}css/$name');
  }

  @override
  String parseCssPropertyResponse(WebDriverResponse response) {
    return parseW3cResponse(response)?.toString();
  }

  @override
  WebDriverRequest buildPropertyRequest(String elementId, String name) {
    return WebDriverRequest.getRequest(
        '${elementPrefix(elementId)}property/$name');
  }

  @override
  String parsePropertyResponse(WebDriverResponse response) {
    return parseW3cResponse(response)?.toString();
  }
}
