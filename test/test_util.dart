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

library webdriver_test_util;

import 'dart:async' show Future;
import 'dart:io' show FileSystemEntity, Platform;
import 'dart:math' show Point, Rectangle;

import 'package:path/path.dart' as path;
import 'package:matcher/matcher.dart' show Matcher, isInstanceOf;
import 'package:webdriver/io.dart'
    show Capabilities, WebDriver, WebElement, createDriver;

final Matcher isWebElement = new isInstanceOf<WebElement>();
final Matcher isRectangle = new isInstanceOf<Rectangle<int>>();
final Matcher isPoint = new isInstanceOf<Point<int>>();

bool isRunningOnTravis() => Platform.environment['TRAVIS'] == 'true';

String get testPagePath {
  if (_testPagePath == null) {
    _testPagePath = _getTestPagePath();
  }
  return _testPagePath;
}

String _getTestPagePath() {
  var testPagePath = path.join(path.current, 'test', 'test_page.html');
  testPagePath = path.absolute(testPagePath);
  if (!FileSystemEntity.isFileSync(testPagePath)) {
    throw new Exception('Could not find the test file at "$testPagePath".'
        ' Make sure you are running tests from the root of the project.');
  }
  return path.toUri(testPagePath).toString();
}

String _testPagePath;

Future<WebDriver> createTestDriver({Map additionalCapabilities}) {
  Map capabilities = Capabilities.chrome;
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

  return createDriver(desired: capabilities);
}
