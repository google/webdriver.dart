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

library webdriver.io_test;

import 'dart:io' show FileSystemEntity, Platform;

import 'package:path/path.dart' as path;
import 'package:webdriver/io.dart' show Capabilities, createDriver;

import 'test_util.dart' as test_util;

void config() {
  test_util.runningOnTravis = Platform.environment['TRAVIS'] == 'true';
  test_util.createTestDriver = ({Map<String, dynamic> additionalCapabilities}) {
    var address = Platform.environment['WEB_TEST_WEBDRIVER_SERVER'];
    if (!address.endsWith('/')) {
      address += '/';
    }
    var uri = Uri.parse(address);
    return createDriver(uri: uri, desired: additionalCapabilities);
  };
  var testSrcDir = Platform.environment['TEST_SRCDIR'];
  String testPagePath;
  if (testSrcDir != null) {
    testPagePath = path.join(testSrcDir, 'com_github_google_webdriver_dart', 'test', 'test_page.html');
  } else {
    testPagePath = path.join('test', 'test_page.html');
  }
  testPagePath = path.absolute(testPagePath);
  if (!FileSystemEntity.isFileSync(testPagePath)) {
    throw new Exception('Could not find the test file at "$testPagePath".'
        ' Make sure you are running tests from the root of the project.');
  }
  test_util.testPagePath = path.toUri(testPagePath).toString();
}
