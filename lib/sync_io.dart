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

library webdriver.sync_io;

import 'dart:convert' show JSON;
import 'dart:io'
    show
    ContentType,
    HttpHeaders;

import 'package:sync_http/sync_http.dart';

import 'package:webdriver/sync_core.dart' as core
    show createDriver, fromExistingSession, WebDriver;
import 'package:webdriver/src/sync/command_processor.dart' show CommandProcessor;
import 'package:webdriver/src/sync/exception.dart' show WebDriverException;

export 'package:webdriver/sync_core.dart' hide createDriver, fromExistingSession;

/// Creates a WebDriver instance connected to the specified WebDriver server.
///
/// Note: WebDriver endpoints will be constructed using [resolve] against
/// [uri]. Therefore, if [uri] does not end with a trailing slash, the
/// last path component will be dropped.
core.WebDriver createDriver({Uri uri, Map<String, dynamic> desired}) =>
    core.createDriver(new IOCommandProcessor(), uri: uri, desired: desired);

/// Creates a WebDriver instance connected to an existing session.
///
/// Note: WebDriver endpoints will be constructed using [resolve] against
/// [uri]. Therefore, if [uri] does not end with a trailing slash, the
/// last path component will be dropped.
core.WebDriver fromExistingSession(String sessionId, {Uri uri}) =>
    core.fromExistingSession(new IOCommandProcessor(), sessionId, uri: uri);

final ContentType _contentTypeJson =
new ContentType("application", "json", charset: "utf-8");

class IOCommandProcessor implements CommandProcessor {

  @override
  dynamic post(Uri uri, dynamic params, {bool value: true}) {
    final request =  SyncHttpClient.postUrl(uri);
    _setUpRequest(request);
    request.headers.contentType = _contentTypeJson;
    if (params != null) {
      var body = JSON.encode(params); // Cannot be changed from UTF8.
      request.write(body);
    }
    return _processResponse(request.close(), value);
  }

  @override
  dynamic get(Uri uri, {bool value: true}) {
    final request = SyncHttpClient.getUrl(uri);
    _setUpRequest(request);
    return _processResponse( request.close(), value);
  }

  @override
  dynamic delete(Uri uri, {bool value: true}) {
    final request =  SyncHttpClient.deleteUrl(uri);
    _setUpRequest(request);
    return _processResponse( request.close(), value);
  }

  @override
  void close() {}

  _processResponse(SyncHttpClientResponse response, bool value) {
    final respDecoded = response.body;
    Map respBody;
    try {
      respBody = JSON.decode(respDecoded);
    } catch (e) {}

    // TODO(staats): Update to infer protocols.
    if (response.statusCode < 200 ||
        response.statusCode > 299 ||
        (respBody is Map
            && respBody['status'] != null
            && respBody['status'] != 0)) {
      throw new WebDriverException(
          httpStatusCode: response.statusCode,
          httpReasonPhrase: response.reasonPhrase,
          jsonResp: respBody);
    }
    if (value && respBody is Map) {
      return respBody['value'];
    }
    return respBody;
  }

  void _setUpRequest(SyncHttpClientRequest request) {
    // TODO(staats): Follow redirects.
    request.headers.add(HttpHeaders.ACCEPT, "application/json");
    request.headers.add(HttpHeaders.CACHE_CONTROL, "no-cache");
  }
}
