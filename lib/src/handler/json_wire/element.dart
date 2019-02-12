import 'dart:math';

import 'package:webdriver/src/common/request.dart';
import 'package:webdriver/src/common/webdriver_handler.dart';

import 'utils.dart';

class JsonWireElementHandler extends ElementHandler {
  @override
  WebDriverRequest buildClickRequest(String elementId) {
    return WebDriverRequest.postRequest('${elementPrefix(elementId)}click');
  }

  @override
  void parseClickResponse(WebDriverResponse response) {
    parseJsonWireResponse(response);
  }

  @override
  WebDriverRequest buildSendKeysRequest(String elementId, String keysToSend) {
    return WebDriverRequest.postRequest('${elementPrefix(elementId)}value', {
      'value': [keysToSend]
    });
  }

  @override
  void parseSendKeysResponse(WebDriverResponse response) {
    parseJsonWireResponse(response);
  }

  @override
  WebDriverRequest buildClearRequest(String elementId) {
    return WebDriverRequest.postRequest('${elementPrefix(elementId)}clear');
  }

  @override
  void parseClearResponse(WebDriverResponse response) {
    parseJsonWireResponse(response);
  }

  @override
  WebDriverRequest buildSelectedRequest(String elementId) {
    return WebDriverRequest.getRequest('${elementPrefix(elementId)}selected');
  }

  @override
  bool parseSelectedResponse(WebDriverResponse response) {
    return parseJsonWireResponse(response);
  }

  @override
  WebDriverRequest buildEnabledRequest(String elementId) {
    return WebDriverRequest.getRequest('${elementPrefix(elementId)}enabled');
  }

  @override
  bool parseEnabledResponse(WebDriverResponse response) {
    return parseJsonWireResponse(response);
  }

  @override
  WebDriverRequest buildDisplayedRequest(String elementId) {
    return WebDriverRequest.getRequest('${elementPrefix(elementId)}displayed');
  }

  @override
  bool parseDisplayedResponse(WebDriverResponse response) {
    return parseJsonWireResponse(response);
  }

  @override
  WebDriverRequest buildLocationRequest(String elementId) {
    return WebDriverRequest.getRequest('${elementPrefix(elementId)}location');
  }

  @override
  Point<int> parseLocationResponse(WebDriverResponse response) {
    final point = parseJsonWireResponse(response);
    return Point(point['x'].toInt(), point['y'].toInt());
  }

  @override
  WebDriverRequest buildSizeRequest(String elementId) {
    return WebDriverRequest.getRequest('${elementPrefix(elementId)}size');
  }

  @override
  Rectangle<int> parseSizeResponse(WebDriverResponse response) {
    final size = parseJsonWireResponse(response);
    return Rectangle<int>(0, 0, size['width'].toInt(), size['height'].toInt());
  }

  @override
  WebDriverRequest buildNameRequest(String elementId) {
    return WebDriverRequest.getRequest('${elementPrefix(elementId)}name');
  }

  @override
  String parseNameResponse(WebDriverResponse response) {
    return parseJsonWireResponse(response);
  }

  @override
  WebDriverRequest buildTextRequest(String elementId) {
    return WebDriverRequest.getRequest('${elementPrefix(elementId)}text');
  }

  @override
  String parseTextResponse(WebDriverResponse response) {
    return parseJsonWireResponse(response);
  }

  @override
  WebDriverRequest buildAttributeRequest(String elementId, String name) {
    return WebDriverRequest.postRequest('execute', {
      'script': '''
    var attr = arguments[0].attributes["$name"];
    if(attr) {
      return attr.value;
    }

    return null;
    ''',
      'args': [
        {jsonWireElementStr: elementId}
      ]
    });
  }

  @override
  String parseAttributeResponse(WebDriverResponse response) {
    return parseJsonWireResponse(response)?.toString();
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
    return parseJsonWireResponse(response)?.toString();
  }

  @override
  WebDriverRequest buildCssPropertyRequest(String elementId, String name) {
    return WebDriverRequest.postRequest('execute', {
      'script':
          'return window.getComputedStyle(arguments[0]).${_cssPropName(name)};',
      'args': [
        {jsonWireElementStr: elementId}
      ]
    });
  }

  @override
  String parseCssPropertyResponse(WebDriverResponse response) {
    return parseJsonWireResponse(response)?.toString();
  }

  @override
  WebDriverRequest buildPropertyRequest(String elementId, String name) {
    return WebDriverRequest.postRequest('execute', {
      'script': 'return arguments[0]["$name"];',
      'args': [
        {jsonWireElementStr: elementId}
      ]
    });
  }

  @override
  String parsePropertyResponse(WebDriverResponse response) {
    return parseJsonWireResponse(response)?.toString();
  }

  /// Convert hyphenated-properties to camelCase.
  String _cssPropName(String name) => name.splitMapJoin(RegExp(r'-(\w)'),
      onMatch: (m) => m.group(1).toUpperCase(), onNonMatch: (m) => m);
}
