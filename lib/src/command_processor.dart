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

part of webdriver;

final ContentType _contentTypeJson =
    new ContentType("application", "json", charset: "utf-8");

class _CommandProcessor {
  final HttpClient client = new HttpClient();

  Lock _lock = new Lock();

  Future<Object> post(Uri uri, dynamic params, {bool value: true}) async {
    await _lock.acquire();
    HttpClientRequest request = await client.postUrl(uri);
    _setUpRequest(request);
    request.headers.contentType = _contentTypeJson;
    if (params != null) {
      var body = UTF8.encode(JSON.encode(params));
      request.contentLength = body.length;
      request.add(body);
    } else {
      request.contentLength = 0;
    }
    return await _processResponse(await request.close(), value);
  }

  Future<Object> get(Uri uri, {bool value: true}) async {
    await _lock.acquire();
    HttpClientRequest request = await client.getUrl(uri);
    _setUpRequest(request);
    return await _processResponse(await request.close(), value);
  }

  Future<Object> delete(Uri uri, {bool value: true}) async {
    await _lock.acquire();
    HttpClientRequest request = await client.deleteUrl(uri);
    _setUpRequest(request);
    return await _processResponse(await request.close(), value);
  }

  _processResponse(HttpClientResponse response, bool value) async {
    var respBody = await UTF8.decodeStream(response);
    _lock.release();
    try {
      respBody = JSON.decode(respBody);
    } catch (e) {}

    if (response.statusCode < 200 ||
        response.statusCode > 299 ||
        (respBody is Map && respBody['status'] != 0)) {
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

  void _setUpRequest(HttpClientRequest request) {
    request.followRedirects = false;
    request.headers.add(HttpHeaders.ACCEPT, "application/json");
    request.headers.add(HttpHeaders.ACCEPT_CHARSET, UTF8.name);
    request.headers.add(HttpHeaders.CACHE_CONTROL, "no-cache");
  }
}
