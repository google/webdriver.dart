// Copyright 2017 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

library webdriver.json_exception;

import '../exception.dart';

abstract class JsonWireWebDriverException implements WebDriverException {
  /// The status value returned in the JSON response (preferred) or the
  /// HTTP status code.
  final int statusCode;

  final String _message;

  /// A message describing the error.
  @override
  String get message => _message;

  factory JsonWireWebDriverException(
      {int httpStatusCode, String httpReasonPhrase, dynamic jsonResp}) {
    if (jsonResp is Map) {
      final status = jsonResp['status'] as int;
      final message = jsonResp['value']['message'] as String;

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

  const JsonWireWebDriverException._(this.statusCode, this._message);

  @override
  String toString() => '$runtimeType ($statusCode): $message';

  @override
  bool operator ==(other) =>
      other.runtimeType == this.runtimeType &&
      other.statusCode == this.statusCode &&
      other.message == this.message;

  @override
  int get hashCode => statusCode + message.hashCode;
}

class InvalidRequestException extends JsonWireWebDriverException {
  const InvalidRequestException(int statusCode, String message)
      : super._(statusCode, message);
}

class UnknownException extends JsonWireWebDriverException {
  const UnknownException(int statusCode, String message)
      : super._(statusCode, message);
}

class NoSuchDriverException extends JsonWireWebDriverException {
  const NoSuchDriverException(int statusCode, String message)
      : super._(statusCode, message);
}

class NoSuchElementException extends JsonWireWebDriverException {
  const NoSuchElementException(int statusCode, String message)
      : super._(statusCode, message);
}

class NoSuchFrameException extends JsonWireWebDriverException {
  const NoSuchFrameException(int statusCode, String message)
      : super._(statusCode, message);
}

class UnknownCommandException extends JsonWireWebDriverException {
  const UnknownCommandException(int statusCode, String message)
      : super._(statusCode, message);
}

class StaleElementReferenceException extends JsonWireWebDriverException {
  const StaleElementReferenceException(int statusCode, String message)
      : super._(statusCode, message);
}

class ElementNotVisibleException extends JsonWireWebDriverException {
  const ElementNotVisibleException(int statusCode, String message)
      : super._(statusCode, message);
}

class InvalidElementStateException extends JsonWireWebDriverException {
  const InvalidElementStateException(int statusCode, String message)
      : super._(statusCode, message);
}

class ElementIsNotSelectableException extends JsonWireWebDriverException {
  const ElementIsNotSelectableException(int statusCode, String message)
      : super._(statusCode, message);
}

class JavaScriptException extends JsonWireWebDriverException {
  const JavaScriptException(int statusCode, String message)
      : super._(statusCode, message);
}

class XPathLookupException extends JsonWireWebDriverException {
  const XPathLookupException(int statusCode, String message)
      : super._(statusCode, message);
}

class TimeoutException extends JsonWireWebDriverException {
  const TimeoutException(int statusCode, String message)
      : super._(statusCode, message);
}

class NoSuchWindowException extends JsonWireWebDriverException {
  const NoSuchWindowException(int statusCode, String message)
      : super._(statusCode, message);
}

class InvalidCookieDomainException extends JsonWireWebDriverException {
  const InvalidCookieDomainException(int statusCode, String message)
      : super._(statusCode, message);
}

class UnableToSetCookieException extends JsonWireWebDriverException {
  const UnableToSetCookieException(int statusCode, String message)
      : super._(statusCode, message);
}

class UnexpectedAlertOpenException extends JsonWireWebDriverException {
  const UnexpectedAlertOpenException(int statusCode, String message)
      : super._(statusCode, message);
}

class NoSuchAlertException extends JsonWireWebDriverException {
  const NoSuchAlertException(int statusCode, String message)
      : super._(statusCode, message);
}

class InvalidElementCoordinatesException extends JsonWireWebDriverException {
  const InvalidElementCoordinatesException(int statusCode, String message)
      : super._(statusCode, message);
}

class IMENotAvailableException extends JsonWireWebDriverException {
  const IMENotAvailableException(int statusCode, String message)
      : super._(statusCode, message);
}

class IMEEngineActivationFailedException extends JsonWireWebDriverException {
  const IMEEngineActivationFailedException(int statusCode, String message)
      : super._(statusCode, message);
}

class InvalidSelectorException extends JsonWireWebDriverException {
  const InvalidSelectorException(int statusCode, String message)
      : super._(statusCode, message);
}

class SessionNotCreatedException extends JsonWireWebDriverException {
  const SessionNotCreatedException(int statusCode, String message)
      : super._(statusCode, message);
}

class MoveTargetOutOfBoundsException extends JsonWireWebDriverException {
  const MoveTargetOutOfBoundsException(int statusCode, String message)
      : super._(statusCode, message);
}
