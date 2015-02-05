// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of webdriver;

abstract class WebDriverException {
  /// Either the status value returned in the JSON response (preferred) or the
  /// HTTP status code.
  final int statusCode;

  /// A message describing the error.
  final String message;

  factory WebDriverException(
      {int httpStatusCode, String httpReasonPhrase, dynamic jsonResp}) {
    if (jsonResp is Map) {
      var status = jsonResp['status'];
      var message = jsonResp['value']['message'];

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
        case 27: // NoAlertOpenError
          return new NoAlertOpenException(status, message);
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

  const WebDriverException._(this.statusCode, this.message);

  String toString() => '$runtimeType ($statusCode): $message';
}

class InvalidRequestException extends WebDriverException {
  InvalidRequestException(statusCode, message) : super._(statusCode, message);
}

class UnknownException extends WebDriverException {
  UnknownException(statusCode, message) : super._(statusCode, message);
}

class NoSuchDriverException extends WebDriverException {
  NoSuchDriverException(statusCode, message) : super._(statusCode, message);
}

class NoSuchElementException extends WebDriverException {
  NoSuchElementException(statusCode, message) : super._(statusCode, message);
}

class NoSuchFrameException extends WebDriverException {
  NoSuchFrameException(statusCode, message) : super._(statusCode, message);
}

class UnknownCommandException extends WebDriverException {
  UnknownCommandException(statusCode, message) : super._(statusCode, message);
}

class StaleElementReferenceException extends WebDriverException {
  StaleElementReferenceException(statusCode, message)
      : super._(statusCode, message);
}

class ElementNotVisibleException extends WebDriverException {
  ElementNotVisibleException(statusCode, message)
      : super._(statusCode, message);
}

class InvalidElementStateException extends WebDriverException {
  InvalidElementStateException(statusCode, message)
      : super._(statusCode, message);
}

class ElementIsNotSelectableException extends WebDriverException {
  ElementIsNotSelectableException(statusCode, message)
      : super._(statusCode, message);
}

class JavaScriptException extends WebDriverException {
  JavaScriptException(statusCode, message) : super._(statusCode, message);
}

class XPathLookupException extends WebDriverException {
  XPathLookupException(statusCode, message) : super._(statusCode, message);
}

class TimeoutException extends WebDriverException {
  TimeoutException(statusCode, message) : super._(statusCode, message);
}

class NoSuchWindowException extends WebDriverException {
  NoSuchWindowException(statusCode, message) : super._(statusCode, message);
}

class InvalidCookieDomainException extends WebDriverException {
  InvalidCookieDomainException(statusCode, message)
      : super._(statusCode, message);
}

class UnableToSetCookieException extends WebDriverException {
  UnableToSetCookieException(statusCode, message)
      : super._(statusCode, message);
}

class UnexpectedAlertOpenException extends WebDriverException {
  UnexpectedAlertOpenException(statusCode, message)
      : super._(statusCode, message);
}

class NoAlertOpenException extends WebDriverException {
  NoAlertOpenException(statusCode, message) : super._(statusCode, message);
}

class InvalidElementCoordinatesException extends WebDriverException {
  InvalidElementCoordinatesException(statusCode, message)
      : super._(statusCode, message);
}

class IMENotAvailableException extends WebDriverException {
  IMENotAvailableException(statusCode, message) : super._(statusCode, message);
}

class IMEEngineActivationFailedException extends WebDriverException {
  IMEEngineActivationFailedException(statusCode, message)
      : super._(statusCode, message);
}

class InvalidSelectorException extends WebDriverException {
  InvalidSelectorException(statusCode, message) : super._(statusCode, message);
}

class SessionNotCreatedException extends WebDriverException {
  SessionNotCreatedException(statusCode, message)
      : super._(statusCode, message);
}

class MoveTargetOutOfBoundsException extends WebDriverException {
  MoveTargetOutOfBoundsException(statusCode, message)
      : super._(statusCode, message);
}
