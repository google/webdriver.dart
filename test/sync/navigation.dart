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

@TestOn("vm")
library webdriver.navigation_test;

import 'package:test/test.dart';
import 'package:webdriver/sync_core.dart';

import 'sync_io_config.dart' as config;

void runTests(config.createTestDriver createTestDriver) {
  group('Navigation', () {
    WebDriver driver;

    setUp(() {
      driver = createTestDriver();
      driver.get(config.testPagePath);
    });

    tearDown(() {
      if (driver != null) {
        driver.quit();
      }
      driver = null;
    });

    test('refresh', () {
      var element = driver.findElement(const By.tagName('button'));
      driver.navigate.refresh();
      try {
        element.name;
      } on StaleElementReferenceException {
        return true;
      }
      return 'expected StaleElementReferenceException';
    });
  }, timeout: new Timeout(new Duration(minutes: 2)));
}
