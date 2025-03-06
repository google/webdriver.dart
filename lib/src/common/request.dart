// Copyright 2019 Google Inc. All Rights Reserved.
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

import 'dart:convert';

enum HttpMethod {
  httpGet('GET'),
  httpPost('POST'),
  httpDelete('DELETE');

  final String name;

  const HttpMethod(this.name);

  @override
  String toString() => 'HttpMethod.$name';
}

/// Request data to send to WebDriver.
///
/// It should be converted to corresponding object in different implementations
/// of [RequestClient].
/// This is useful to remove dependency on implementation specific request
/// class.
class WebDriverRequest {
  final HttpMethod? method;

  final String? uri;

  final String? body;

  WebDriverRequest(this.method, this.uri, this.body);

  WebDriverRequest.postRequest(this.uri, [Object? params])
      : method = HttpMethod.httpPost,
        body = params == null ? '{}' : json.encode(params);

  WebDriverRequest.getRequest(this.uri)
      : method = HttpMethod.httpGet,
        body = null;

  WebDriverRequest.deleteRequest(this.uri)
      : method = HttpMethod.httpDelete,
        body = null;

  /// Represents request that has no http request to make.
  ///
  /// Useful when the endpoint is not supported but can be inferred in some
  /// degree locally.
  WebDriverRequest.nullRequest(this.body)
      : method = null,
        uri = null;

  @override
  String toString() => '${method!.name} $uri: $body';
}

/// Request data got from WebDriver.
///
/// It should be converted from corresponding object in different
/// implementations of [RequestClient].
/// This is useful to remove dependency on implementation specific response
/// class.
class WebDriverResponse {
  final int? statusCode;

  final String? reasonPhrase;
  final String? body;

  WebDriverResponse(this.statusCode, this.reasonPhrase, this.body);

  @override
  String toString() => '$reasonPhrase ($statusCode): $body';
}
