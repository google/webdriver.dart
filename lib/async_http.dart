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

import 'package:http/http.dart' as http show Client;

import 'async_core.dart' as core
    show
        createDriver,
        fromExistingSession,
        fromExistingSessionSync,
        WebDriver,
        WebDriverSpec;
import 'src/request/async_http_request_client.dart';

export 'package:webdriver/async_core.dart'
    hide createDriver, fromExistingSession, fromExistingSessionSync;
export 'package:webdriver/src/request/async_http_request_client.dart';

/// Creates a new async WebDriver using [AsyncHttpRequestClient].
///
/// Note: WebDriver endpoints will be constructed using [resolve] against
/// [uri]. Therefore, if [uri] does not end with a trailing slash, the
/// last path component will be dropped.
Future<core.WebDriver> createDriver({
  Uri? uri,
  Map<String, Object?>? desired,
  core.WebDriverSpec spec = core.WebDriverSpec.Auto,
  Map<String, String> webDriverHeaders = const {},
  http.Client? httpClient,
}) =>
    core.createDriver(
      (prefix) => AsyncHttpRequestClient(
        prefix,
        headers: webDriverHeaders,
        httpClient: httpClient,
      ),
      uri: uri,
      desired: desired,
      spec: spec,
    );

/// Creates an async WebDriver from existing session using
/// [AsyncHttpRequestClient].
///
/// Note: WebDriver endpoints will be constructed using [resolve] against
/// [uri]. Therefore, if [uri] does not end with a trailing slash, the
/// last path component will be dropped.
Future<core.WebDriver> fromExistingSession(
  String sessionId, {
  Uri? uri,
  core.WebDriverSpec spec = core.WebDriverSpec.Auto,
  http.Client? httpClient,
}) =>
    core.fromExistingSession(
      (prefix) => AsyncHttpRequestClient(prefix, httpClient: httpClient),
      sessionId,
      uri: uri,
      spec: spec,
    );

/// Creates an async WebDriver from existing session with a sync function using
/// [AsyncHttpRequestClient].
///
/// The function is sync, so all necessary information ([sessionId], [spec],
/// [capabilities]) has to be given. Because otherwise, making a call to
/// WebDriver server will make this function async.
///
/// Note: WebDriver endpoints will be constructed using [resolve] against
/// [uri]. Therefore, if [uri] does not end with a trailing slash, the
/// last path component will be dropped.
core.WebDriver fromExistingSessionSync(
  String sessionId,
  core.WebDriverSpec spec, {
  Uri? uri,
  Map<String, Object?>? capabilities,
  http.Client? httpClient,
}) =>
    core.fromExistingSessionSync(
      (prefix) => AsyncHttpRequestClient(prefix, httpClient: httpClient),
      sessionId,
      spec,
      uri: uri,
      capabilities: capabilities,
    );
