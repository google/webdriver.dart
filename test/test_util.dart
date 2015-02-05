// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library webdriver_test_util;

import 'dart:async';
import 'dart:io' hide Platorm;
import 'dart:io' as io show Platform;

import 'package:path/path.dart' as path;
import 'package:unittest/unittest.dart';
import 'package:webdriver/webdriver.dart';

final Matcher isWebElement = new isInstanceOf<WebElement>();
final Matcher isSize = new isInstanceOf<Size>();
final Matcher isPoint = new isInstanceOf<Point>();

bool isRunningOnTravis() => io.Platform.environment['TRAVIS'] == 'true';

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
  Map env = io.Platform.environment;

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

  return WebDriver.createDriver(desiredCapabilities: capabilities);
}
