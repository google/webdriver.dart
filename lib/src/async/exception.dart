// Copyright 2015 Google Inc. All Rights Reserved.
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

library webdriver.exception;

abstract class WebDriverException implements Exception {
  /// Either the status value returned in the JSON response (preferred) or the
  /// HTTP status code.
  final int statusCode;

  /// A message describing the error.
  final String message;

  factory WebDriverException(
      {int httpStatusCode, String httpReasonPhrase, dynamic jsonResp}) {
    if (jsonResp is Map) {
      var status = jsonResp['status'] as int;
      var message = jsonResp['value']['message'] as String;

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
      return new InvalidRequestException(httpStatusCode, jsonResp as String);
    }
    return new InvalidRequestException(httpStatusCode, httpReasonPhrase);
  }

  const WebDriverException._(this.statusCode, this.message);

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

class InvalidRequestException extends WebDriverException {
  const InvalidRequestException(int statusCode, String message)
      : super._(statusCode, message);
}

class UnknownException extends WebDriverException {
  const UnknownException(int statusCode, String message)
      : super._(statusCode, message);
}

class NoSuchDriverException extends WebDriverException {
  const NoSuchDriverException(int statusCode, String message)
      : super._(statusCode, message);
}

class NoSuchElementException extends WebDriverException {
  const NoSuchElementException(int statusCode, String message)
      : super._(statusCode, message);
}

class NoSuchFrameException extends WebDriverException {
  const NoSuchFrameException(int statusCode, String message)
      : super._(statusCode, message);
}

class UnknownCommandException extends WebDriverException {
  const UnknownCommandException(int statusCode, String message)
      : super._(statusCode, message);
}

class StaleElementReferenceException extends WebDriverException {
  const StaleElementReferenceException(int statusCode, String message)
      : super._(statusCode, message);
}

class ElementNotVisibleException extends WebDriverException {
  const ElementNotVisibleException(int statusCode, String message)
      : super._(statusCode, message);
}

class InvalidElementStateException extends WebDriverException {
  const InvalidElementStateException(int statusCode, String message)
      : super._(statusCode, message);
}

class ElementIsNotSelectableException extends WebDriverException {
  const ElementIsNotSelectableException(int statusCode, String message)
      : super._(statusCode, message);
}

class JavaScriptException extends WebDriverException {
  const JavaScriptException(int statusCode, String message)
      : super._(statusCode, message);
}

class XPathLookupException extends WebDriverException {
  const XPathLookupException(int statusCode, String message)
      : super._(statusCode, message);
}

class TimeoutException extends WebDriverException {
  const TimeoutException(int statusCode, String message)
      : super._(statusCode, message);
}

class NoSuchWindowException extends WebDriverException {
  const NoSuchWindowException(int statusCode, String message)
      : super._(statusCode, message);
}

class InvalidCookieDomainException extends WebDriverException {
  const InvalidCookieDomainException(int statusCode, String message)
      : super._(statusCode, message);
}

class UnableToSetCookieException extends WebDriverException {
  const UnableToSetCookieException(int statusCode, String message)
      : super._(statusCode, message);
}

class UnexpectedAlertOpenException extends WebDriverException {
  const UnexpectedAlertOpenException(int statusCode, String message)
      : super._(statusCode, message);
}

class NoSuchAlertException extends WebDriverException {
  const NoSuchAlertException(int statusCode, String message)
      : super._(statusCode, message);
}

class InvalidElementCoordinatesException extends WebDriverException {
  const InvalidElementCoordinatesException(int statusCode, String message)
      : super._(statusCode, message);
}

class IMENotAvailableException extends WebDriverException {
  const IMENotAvailableException(int statusCode, String message)
      : super._(statusCode, message);
}

class IMEEngineActivationFailedException extends WebDriverException {
  const IMEEngineActivationFailedException(int statusCode, String message)
      : super._(statusCode, message);
}

class InvalidSelectorException extends WebDriverException {
  const InvalidSelectorException(int statusCode, String message)
      : super._(statusCode, message);
}

class SessionNotCreatedException extends WebDriverException {
  const SessionNotCreatedException(int statusCode, String message)
      : super._(statusCode, message);
}

class MoveTargetOutOfBoundsException extends WebDriverException {
  const MoveTargetOutOfBoundsException(int statusCode, String message)
      : super._(statusCode, message);
}
