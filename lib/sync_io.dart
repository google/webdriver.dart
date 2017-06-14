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

import 'package:webdriver/sync_core.dart' as core
    show createDriver, fromExistingSession, WebDriver, WebDriverSpec;

export 'package:webdriver/sync_core.dart'
    hide createDriver, fromExistingSession;

/// Creates a WebDriver instance connected to the specified WebDriver server.
///
/// Note: WebDriver endpoints will be constructed using [resolve] against
/// [uri]. Therefore, if [uri] does not end with a trailing slash, the
/// last path component will be dropped.
core.WebDriver createDriver(
        {Uri uri,
        Map<String, dynamic> desired,
        core.WebDriverSpec spec = core.WebDriverSpec.JsonWire}) =>
    core.createDriver(uri: uri, desired: desired, spec: spec);

/// Creates a WebDriver instance connected to an existing session.
///
/// Note: WebDriver endpoints will be constructed using [resolve] against
/// [uri]. Therefore, if [uri] does not end with a trailing slash, the
/// last path component will be dropped.
core.WebDriver fromExistingSession(String sessionId,
        {Uri uri, core.WebDriverSpec spec = core.WebDriverSpec.JsonWire}) =>
    core.fromExistingSession(sessionId, uri: uri, spec: spec);
