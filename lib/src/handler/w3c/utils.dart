import 'dart:convert';

import 'package:webdriver/src/common/web_element.dart';

import '../../common/exception.dart';
import '../../common/request.dart';

// Source: https://www.w3.org/TR/webdriver/#elements
const String w3cElementStr = 'element-6066-11e4-a52e-4f735466cecf';

dynamic parseW3cResponse(WebDriverResponse response) {
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

  if (response.statusCode < 200 || response.statusCode > 299) {
    final value = responseBody['value'];
    // See https://www.w3.org/TR/webdriver/#handling-errors
    switch (value['error']) {
      case 'element click intercepted':
        throw new ElementClickInterceptedException(
            response.statusCode, value['message']);

      case 'element not interactable':
        throw new ElementNotInteractableException(
            response.statusCode, value['message']);

      case 'insecure certificate':
        throw new InsecureCertificateException(
            response.statusCode, value['message']);

      case 'invalid argument':
        throw new InvalidArgumentException(
            response.statusCode, value['message']);

      case 'invalid cookie domain':
        throw new InvalidCookieDomainException(
            response.statusCode, value['message']);

      case 'invalid element state':
        throw new InvalidElementStateException(
            response.statusCode, value['message']);

      case 'invalid selector':
        throw new InvalidSelectorException(
            response.statusCode, value['message']);

      case 'invalid session id':
        throw new InvalidSessionIdException(
            response.statusCode, value['message']);

      case 'javascript error':
        throw new JavaScriptException(response.statusCode, value['message']);

      case 'move target out of bounds':
        throw new MoveTargetOutOfBoundsException(
            response.statusCode, value['message']);

      case 'no such alert':
        throw new NoSuchAlertException(response.statusCode, value['message']);

      case 'no such cookie':
        throw new NoSuchCookieException(response.statusCode, value['message']);

      case 'no such element':
        throw new NoSuchElementException(response.statusCode, value['message']);

      case 'no such frame':
        throw new NoSuchFrameException(response.statusCode, value['message']);

      case 'no such window':
        throw new NoSuchWindowException(response.statusCode, value['message']);

      case 'script timeout':
        throw new ScriptTimeoutException(response.statusCode, value['message']);

      case 'session not created':
        throw new SessionNotCreatedException(
            response.statusCode, value['message']);

      case 'stale element reference':
        throw new StaleElementReferenceException(
            response.statusCode, value['message']);

      case 'timeout':
        throw new TimeoutException(response.statusCode, value['message']);

      case 'unable to set cookie':
        throw new UnableToSetCookieException(
            response.statusCode, value['message']);

      case 'unable to capture screen':
        throw new UnableToCaptureScreenException(
            response.statusCode, value['message']);

      case 'unexpected alert open':
        throw new UnexpectedAlertOpenException(
            response.statusCode, value['message']);

      case 'unknown command':
        throw new UnknownCommandException(
            response.statusCode, value['message']);

      case 'unknown error':
        throw new UnknownException(response.statusCode, value['message']);

      case 'unknown method':
        throw new UnknownMethodException(response.statusCode, value['message']);

      case 'unsupported operation':
        throw new UnsupportedOperationException(
            response.statusCode, value['message']);
      default:
        throw new WebDriverException(response.statusCode, value['message']);
    }
  }

  if (responseBody is Map) {
    return responseBody['value'];
  }

  return responseBody;
}

/// Prefix to represent element in webdriver uri.
///
/// When [elementId] is null, it means root element.
String elementPrefix(String elementId) =>
    elementId == null ? '' : 'element/$elementId/';

dynamic deserialize(result, dynamic Function(String) createElement) {
  if (result is Map) {
    if (result.containsKey(w3cElementStr)) {
      return createElement(result[w3cElementStr]);
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
    return {w3cElementStr: obj.id};
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
