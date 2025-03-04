// Copyright 2025 Google Inc. All Rights Reserved.
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

import 'dart:async';
import 'dart:convert' show utf8;

import 'package:http/http.dart' as http;

import '../../support/async.dart';

import '../common/request.dart';
import '../common/request_client.dart';

/// Async request client using the
/// specified or default [http.Client] from `package:http`.
class AsyncHttpRequestClient extends AsyncRequestClient {
  final Lock _lock = Lock();
  final Map<String, String> _headers;
  final http.Client _httpClient;

  AsyncHttpRequestClient(
    super.prefix, {
    Map<String, String> headers = const {},
    http.Client? httpClient,
  })  : _headers = headers,
        _httpClient = httpClient ?? http.Client();

  @override
  Future<WebDriverResponse> sendRaw(WebDriverRequest request) async {
    await _lock.acquire();

    try {
      final requestUri = resolve(request.uri!);
      final httpRequest = http.Request(request.method!.name, requestUri)
        ..followRedirects = true
        ..headers.addAll(_headers)
        ..headers.addAll({
          'Accept': 'application/json',
          'Accept-Charset': utf8.name,
          'Cache-Control': 'no-cache',
        });

      final requestBody = request.body;
      if (requestBody != null && requestBody.isNotEmpty) {
        httpRequest
          ..headers['Content-Type'] = 'application/json'
          ..bodyBytes = utf8.encode(requestBody);
      }

      final response = await _httpClient.send(httpRequest);
      return WebDriverResponse(
        response.statusCode,
        response.reasonPhrase,
        await utf8.decodeStream(response.stream),
      );
    } finally {
      _lock.release();
    }
  }

  @override
  String toString() => 'AsyncHttp';
}
