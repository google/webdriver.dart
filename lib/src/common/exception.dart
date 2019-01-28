/// Base exception for anything unexpected happened in Web Driver requests.
class WebDriverException implements Exception {
  /// Either the status value returned in the JSON response (preferred) or the
  /// HTTP status code.
  final int statusCode;

  /// A message describing the error.
  final String message;

  const WebDriverException(this.statusCode, this.message);

  @override
  String toString() =>
      '$runtimeType ($statusCode): ' +
      (message == null || message.isEmpty ? '<no message>' : message);

  @override
  bool operator ==(other) =>
      other.runtimeType == runtimeType &&
      other.statusCode == statusCode &&
      other.message == message;

  @override
  int get hashCode => statusCode + message.hashCode;
}

class InvalidArgumentException extends WebDriverException {
  const InvalidArgumentException(statusCode, message)
      : super(statusCode, message);
}

class InvalidRequestException extends WebDriverException {
  const InvalidRequestException(statusCode, message)
      : super(statusCode, message);
}

class InvalidResponseException extends WebDriverException {
  const InvalidResponseException(statusCode, message)
      : super(statusCode, message);
}

class UnknownException extends WebDriverException {
  const UnknownException(statusCode, message) : super(statusCode, message);
}

class NoSuchDriverException extends WebDriverException {
  const NoSuchDriverException(statusCode, message) : super(statusCode, message);
}

class NoSuchElementException extends WebDriverException {
  const NoSuchElementException(statusCode, message)
      : super(statusCode, message);
}

class NoSuchFrameException extends WebDriverException {
  const NoSuchFrameException(statusCode, message) : super(statusCode, message);
}

class UnknownCommandException extends WebDriverException {
  const UnknownCommandException(statusCode, message)
      : super(statusCode, message);
}

class StaleElementReferenceException extends WebDriverException {
  const StaleElementReferenceException(statusCode, message)
      : super(statusCode, message);
}

class ElementNotVisibleException extends WebDriverException {
  const ElementNotVisibleException(statusCode, message)
      : super(statusCode, message);
}

class InvalidElementStateException extends WebDriverException {
  const InvalidElementStateException(statusCode, message)
      : super(statusCode, message);
}

class ElementIsNotSelectableException extends WebDriverException {
  const ElementIsNotSelectableException(statusCode, message)
      : super(statusCode, message);
}

class JavaScriptException extends WebDriverException {
  const JavaScriptException(statusCode, message) : super(statusCode, message);
}

class XPathLookupException extends WebDriverException {
  const XPathLookupException(statusCode, message) : super(statusCode, message);
}

class TimeoutException extends WebDriverException {
  const TimeoutException(statusCode, message) : super(statusCode, message);
}

class NoSuchWindowException extends WebDriverException {
  const NoSuchWindowException(statusCode, message) : super(statusCode, message);
}

class InvalidCookieDomainException extends WebDriverException {
  const InvalidCookieDomainException(statusCode, message)
      : super(statusCode, message);
}

class UnableToSetCookieException extends WebDriverException {
  const UnableToSetCookieException(statusCode, message)
      : super(statusCode, message);
}

class UnexpectedAlertOpenException extends WebDriverException {
  const UnexpectedAlertOpenException(statusCode, message)
      : super(statusCode, message);
}

class NoSuchAlertException extends WebDriverException {
  const NoSuchAlertException(statusCode, message) : super(statusCode, message);
}

class ScriptTimeoutException extends WebDriverException {
  const ScriptTimeoutException(statusCode, message)
      : super(statusCode, message);
}

class InvalidElementCoordinatesException extends WebDriverException {
  const InvalidElementCoordinatesException(statusCode, message)
      : super(statusCode, message);
}

class IMENotAvailableException extends WebDriverException {
  const IMENotAvailableException(statusCode, message)
      : super(statusCode, message);
}

class IMEEngineActivationFailedException extends WebDriverException {
  const IMEEngineActivationFailedException(statusCode, message)
      : super(statusCode, message);
}

class InvalidSelectorException extends WebDriverException {
  const InvalidSelectorException(statusCode, message)
      : super(statusCode, message);
}

class SessionNotCreatedException extends WebDriverException {
  const SessionNotCreatedException(statusCode, message)
      : super(statusCode, message);
}

class MoveTargetOutOfBoundsException extends WebDriverException {
  const MoveTargetOutOfBoundsException(statusCode, message)
      : super(statusCode, message);
}

/// The Element Click command could not be completed because the element
/// receiving the events is obscuring the element that was requested clicked.
class ElementClickInterceptedException extends WebDriverException {
  const ElementClickInterceptedException(statusCode, message)
      : super(statusCode, message);
}

/// A command could not be completed because the element is not pointer- or
/// keyboard interactable.
class ElementNotInteractableException extends WebDriverException {
  const ElementNotInteractableException(statusCode, message)
      : super(statusCode, message);
}

/// Navigation caused the user agent to hit a certificate warning, which is
/// usually the result of an expired or invalid TLS certificate.
class InsecureCertificateException extends WebDriverException {
  const InsecureCertificateException(statusCode, message)
      : super(statusCode, message);
}

/// Occurs if the given session id is not in the list of active sessions,
/// meaning the session either does not exist or that it’s not active.
class InvalidSessionIdException extends WebDriverException {
  const InvalidSessionIdException(statusCode, message)
      : super(statusCode, message);
}

/// No cookie matching the given path name was found amongst the associated
/// cookies of the current browsing context’s active document.
class NoSuchCookieException extends WebDriverException {
  const NoSuchCookieException(statusCode, message) : super(statusCode, message);
}

/// A screen capture was made impossible.
class UnableToCaptureScreenException extends WebDriverException {
  const UnableToCaptureScreenException(statusCode, message)
      : super(statusCode, message);
}

/// The requested command matched a known URL but did not match an method for
/// that URL.
class UnknownMethodException extends WebDriverException {
  const UnknownMethodException(statusCode, message)
      : super(statusCode, message);
}

/// Indicates that a command that should have executed properly cannot be
/// supported for some reason.
class UnsupportedOperationException extends WebDriverException {
  const UnsupportedOperationException(statusCode, message)
      : super(statusCode, message);
}

/// Temporary method to emulate the original json wire exception parsing logic.
WebDriverException getExceptionFromJsonWireResponse(
    {int httpStatusCode, String httpReasonPhrase, dynamic jsonResp}) {
  if (jsonResp is Map) {
    final status = jsonResp['status'];
    final message = jsonResp['value']['message'];

    switch (status) {
      case 0:
        throw new StateError(
            'Not a WebDriverError Status: 0 Message: $message');
      case 6: // NoSuchDriver
        return new NoSuchDriverException(status, message);
      case 7: // NoSuchElement
        return new NoSuchElementException(status, message);
      case 8: // NoSuchFrame
        return new NoSuchFrameException(status, message);
      case 9: // UnknownCommand
        return new UnknownCommandException(status, message);
      case 10: // StaleElementReferenceException
        return new StaleElementReferenceException(status, message);
      case 11: // ElementNotVisible
        return new ElementNotVisibleException(status, message);
      case 12: // InvalidElementState
        return new InvalidElementStateException(status, message);
      case 15: // ElementIsNotSelectable
        return new ElementIsNotSelectableException(status, message);
      case 17: // JavaScriptError
        return new JavaScriptException(status, message);
      case 19: // XPathLookupError
        return new XPathLookupException(status, message);
      case 21: // Timeout
        return new TimeoutException(status, message);
      case 23: // NoSuchWindow
        return new NoSuchWindowException(status, message);
      case 24: // InvalidCookieDomain
        return new InvalidCookieDomainException(status, message);
      case 25: // UnableToSetCookie
        return new UnableToSetCookieException(status, message);
      case 26: // UnexpectedAlertOpen
        return new UnexpectedAlertOpenException(status, message);
      case 27: // NoSuchAlert
        return new NoSuchAlertException(status, message);
      case 28: // ScriptTimeout
        return new ScriptTimeoutException(status, message);
      case 29: // InvalidElementCoordinates
        return new InvalidElementCoordinatesException(status, message);
      case 30: // IMENotAvailable
        return new IMENotAvailableException(status, message);
      case 31: // IMEEngineActivationFailed
        return new IMEEngineActivationFailedException(status, message);
      case 32: // InvalidSelector
        return new InvalidSelectorException(status, message);
      case 33: // SessionNotCreatedException
        return new SessionNotCreatedException(status, message);
      case 34: // MoveTargetOutOfBounds
        return new MoveTargetOutOfBoundsException(status, message);
      case 13: // UnknownError
      default: // new error?
        return new UnknownException(status, message);
    }
  }
  if (jsonResp != null) {
    return new InvalidRequestException(httpStatusCode, jsonResp);
  }
  return new InvalidRequestException(httpStatusCode, httpReasonPhrase);
}

/// Temporary method to emulate the original w3c exception parsing logic.
WebDriverException getExceptionFromW3cResponse(
    {int httpStatusCode, String httpReasonPhrase, dynamic jsonResp}) {
  if (jsonResp is Map && jsonResp.keys.contains('value')) {
    final value = jsonResp['value'];

    switch (value['error']) {
      case 'invalid argument':
        return new InvalidArgumentException(httpStatusCode, value['message']);
      case 'no such element':
        return new NoSuchElementException(httpStatusCode, value['message']);
      default:
        return new WebDriverException(httpStatusCode, value['message']);
    }
  }

  return new InvalidResponseException(httpStatusCode, jsonResp.toString());
}
