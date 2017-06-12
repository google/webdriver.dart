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

library io_test_util;

import 'dart:io' show Platform;

import 'package:webdriver/sync_core.dart' show Capabilities, WebDriver;
import 'package:webdriver/sync_io.dart' show createDriver;

export '../test_util.dart';

typedef WebDriver createTestDriver(
    {Map<String, dynamic> additionalCapabilities});

final Uri _defaultChromeUri = Uri.parse('http://127.0.0.1:4444/wd/hub/');
final Uri _defaultFirefoxUri = Uri.parse('http://127.0.0.1:4444/');

/// TODO(staats): this needs to be the W3C spec.
WebDriver createFirefoxTestDriver(
    {Map<String, dynamic> additionalCapabilities}) {
  final capabilities = Capabilities.firefox;

  if (additionalCapabilities != null) {
    capabilities.addAll(additionalCapabilities);
  }
  return createDriver(uri: _defaultFirefoxUri, desired: capabilities);
}

WebDriver createChromeTestDriver(
    {Map<String, dynamic> additionalCapabilities}) {
  var capabilities = Capabilities.chrome;
  Map env = Platform.environment;

  Map chromeOptions = {};

  if (env['CHROMEDRIVER_BINARY'] != null) {
    chromeOptions['binary'] = env['CHROMEDRIVER_BINARY'];
  }

  if (env['CHROMEDRIVER_ARGS'] != null) {
    chromeOptions['args'] = env['CHROMEDRIVER_ARGS'].split(' ');
  }

  if (chromeOptions.isNotEmpty) {
    capabilities['chromeOptions'] = chromeOptions;
  }

  if (additionalCapabilities != null) {
    capabilities.addAll(additionalCapabilities);
  }

  return createDriver(uri: _defaultChromeUri, desired: additionalCapabilities);
}
