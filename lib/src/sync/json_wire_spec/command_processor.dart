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


import 'dart:convert' show JSON;
import 'dart:io' show ContentType, HttpHeaders;

import 'package:sync_http/sync_http.dart';

import '../command_processor.dart';
import '../exception.dart' show WebDriverException;

final ContentType _contentTypeJson =
  new ContentType("application", "json", charset: "utf-8");

class JsonWireCommandProcessor implements CommandProcessor {

  @override
  dynamic post(Uri uri, dynamic params, {bool value: true}) {
    final request = SyncHttpClient.postUrl(uri);
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
    return _processResponse(request.close(), value);
  }

  @override
  dynamic delete(Uri uri, {bool value: true}) {
    final request = SyncHttpClient.deleteUrl(uri);
    _setUpRequest(request);
    return _processResponse(request.close(), value);
  }

  @override
  void close() {}

  _processResponse(SyncHttpClientResponse response, bool value) {
    final respDecoded = response.body;
    Map respBody;
    try {
      respBody = JSON.decode(respDecoded);
    } catch (e) {}

    if (response.statusCode < 200 ||
        response.statusCode > 299 ||
        (respBody is Map &&
            respBody['status'] != null &&
            respBody['status'] != 0)) {
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
