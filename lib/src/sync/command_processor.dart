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

library webdriver.command_processor;

import 'dart:convert' show JSON;
import 'dart:io' show ContentType, HttpHeaders;

import 'package:sync_http/sync_http.dart';

final ContentType _contentTypeJson =
    new ContentType("application", "json", charset: "utf-8");

typedef dynamic ResponseProcessor(SyncHttpClientResponse response, bool value);

dynamic _defaultProcessor(SyncHttpClientResponse response, bool value) =>
    JSON.decode(response.body);

/// Interface for synchronous HTTP access.
abstract class CommandProcessor {
  Object post(Uri uri, dynamic params, {bool value: true});

  Object get(Uri uri, {bool value: true});

  Object delete(Uri uri, {bool value: true});

  void close();
}

/// Standard command processor for use with sync_http package.
class SyncHttpCommandProcessor implements CommandProcessor {
  final ResponseProcessor _responseProcessor;

  SyncHttpCommandProcessor({ResponseProcessor processor = null})
      : this._responseProcessor = processor ?? _defaultProcessor;

  @override
  dynamic post(Uri uri, dynamic params, {bool value: true}) {
    final request = SyncHttpClient.postUrl(uri);
    _setUpRequest(request);
    request.headers.contentType = _contentTypeJson;
    if (params != null) {
      var body = JSON.encode(params); // Cannot be changed from UTF8.
      request.write(body);
    }
    return _responseProcessor(request.close(), value);
  }

  @override
  dynamic get(Uri uri, {bool value: true}) {
    final request = SyncHttpClient.getUrl(uri);
    _setUpRequest(request);
    return _responseProcessor(request.close(), value);
  }

  @override
  dynamic delete(Uri uri, {bool value: true}) {
    final request = SyncHttpClient.deleteUrl(uri);
    _setUpRequest(request);
    return _responseProcessor(request.close(), value);
  }

  @override
  void close() {}

  void _setUpRequest(SyncHttpClientRequest request) {
    // TODO(staats): Follow redirects.
    request.headers.add(HttpHeaders.ACCEPT, "application/json");
    request.headers.add(HttpHeaders.CACHE_CONTROL, "no-cache");
  }
}
