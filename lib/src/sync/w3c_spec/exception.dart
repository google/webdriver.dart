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

library webdriver.w3c_exception;

import '../exception.dart';

class W3cWebDriverException implements WebDriverException {
  /// The HTTP status code.
  final int httpStatusCode;

  final String _message;

  /// Error type.
  final String error;

  /// Stacktrace
  final String stackTrace;

  /// A message describing the error.
  @override
  String get message => _message;

  factory W3cWebDriverException({int httpStatusCode, dynamic jsonResp}) {
    if (jsonResp is Map && jsonResp.keys.contains('value')) {
      final value = jsonResp['value'];
      final error = value['error'];
      final message = value['message'];
      final stacktrace = value['stacktrace'];

      return new W3cWebDriverException._(
          httpStatusCode, error, message, stacktrace);
    }
    return new InvalidResponseW3cWebDriverException(httpStatusCode);
  }

  const W3cWebDriverException._(
      this.httpStatusCode, this.error, this._message, this.stackTrace);

  @override
  String toString() => '$runtimeType ($httpStatusCode): $message';

  @override
  bool operator ==(other) =>
      other != null &&
      other.runtimeType == this.runtimeType &&
      other.statusCode == this.httpStatusCode &&
      other.message == this.message &&
      other.error == this.error;

  @override
  int get hashCode => httpStatusCode + message.hashCode;
}

/// Thrown in case of invalid responses.
class InvalidResponseW3cWebDriverException extends W3cWebDriverException {
  const InvalidResponseW3cWebDriverException(int httpStatusCode)
      : super._(httpStatusCode, null, null, null);
}
