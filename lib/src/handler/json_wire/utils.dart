import 'dart:convert';

import 'package:webdriver/src/common/web_element.dart';

import '../../common/exception.dart';
import '../../common/request.dart';

/// Magic constants -- identifiers indicating a value is an element.
/// Source: https://github.com/SeleniumHQ/selenium/wiki/JsonWireProtocol
const String jsonWireElementStr = 'ELEMENT';

dynamic parseJsonWireResponse(WebDriverResponse response,
    {bool valueOnly = true}) {
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

  if (response.statusCode < 200 ||
      response.statusCode > 299 ||
      (responseBody is Map &&
          responseBody['status'] != null &&
          responseBody['status'] != 0)) {
    final status = responseBody['status'];
    final message = responseBody['value']['message'];

    switch (status) {
      case 0:
        throw new StateError(
            'Not a WebDriverError Status: 0 Message: $message');
      case 6:
        throw new NoSuchDriverException(status, message);
      case 7:
        throw new NoSuchElementException(status, message);
      case 8:
        throw new NoSuchFrameException(status, message);
      case 9:
        throw new UnknownCommandException(status, message);
      case 10:
        throw new StaleElementReferenceException(status, message);
      case 11:
        throw new ElementNotVisibleException(status, message);
      case 12:
        throw new InvalidElementStateException(status, message);
      case 15:
        throw new ElementIsNotSelectableException(status, message);
      case 17:
        throw new JavaScriptException(status, message);
      case 19:
        throw new XPathLookupException(status, message);
      case 21:
        throw new TimeoutException(status, message);
      case 23:
        throw new NoSuchWindowException(status, message);
      case 24:
        throw new InvalidCookieDomainException(status, message);
      case 25:
        throw new UnableToSetCookieException(status, message);
      case 26:
        throw new UnexpectedAlertOpenException(status, message);
      case 27:
        throw new NoSuchAlertException(status, message);
      case 28:
        throw new ScriptTimeoutException(status, message);
      case 29:
        throw new InvalidElementCoordinatesException(status, message);
      case 30:
        throw new IMENotAvailableException(status, message);
      case 31:
        throw new IMEEngineActivationFailedException(status, message);
      case 32:
        throw new InvalidSelectorException(status, message);
      case 33:
        throw new SessionNotCreatedException(status, message);
      case 34:
        throw new MoveTargetOutOfBoundsException(status, message);
      case 13:
        throw new UnknownException(status, message);
      default:
        throw new WebDriverException(status, message);
    }
  }

  if (valueOnly && responseBody is Map) {
    return responseBody['value'];
  }

  return responseBody;
}

/// Prefix to represent element in webdriver uri.
///
/// When [elementId] is null, it means root element.
String elementPrefix(String elementId) =>
    elementId == null ? '' : 'element/$elementId/';

/// Deserializes json object returned by WebDriver server.
///
/// Mainly it handles the element object rebuild.
dynamic deserialize(result, dynamic Function(String) createElement) {
  if (result is Map) {
    if (result.containsKey(jsonWireElementStr)) {
      return createElement(result[jsonWireElementStr]);
    } else {
      final newResult = {};
      result.forEach((key, value) {
        newResult[key] = deserialize(value, createElement);
      });
      return newResult;
    }
  } else if (result is List) {
    return result.map((item) => deserialize(item, createElement)).toList();
  } else {
    return result;
  }
}

dynamic serialize(dynamic obj) {
  if (obj is WebElement) {
    return {jsonWireElementStr: obj.id};
  }

  if (obj is Map) {
    final newResult = <String, dynamic>{};
    for (final item in obj.entries) {
      newResult[item.key] = serialize(item.value);
    }

    return newResult;
  }

  if (obj is List) {
    return obj.map((item) => serialize(item)).toList();
  }

  return obj;
}
