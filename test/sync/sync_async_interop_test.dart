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

library webdriver.support.async_test;

import 'package:test/test.dart';
import 'package:webdriver/sync_io.dart';
import 'package:webdriver/async_core.dart' as async_core;

import 'sync_io_config.dart' as config;

void runTests(config.createTestDriver createTestDriver) {
  group('Sync-async interop', () {
    WebDriver driver;

    setUp(() {
      driver = createTestDriver();
    });

    tearDown(() {
      if (driver != null) {
        driver.quit();
      }
      driver = null;
    });

    test('sync to async works', () {
      final asyncDriver = driver.asyncDriver;
      expect(asyncDriver, new isInstanceOf<async_core.WebDriver>());
      asyncDriver.get(config.testPagePath);
      driver.findElement(const By.tagName('button'));
    });
  }, timeout: new Timeout(new Duration(minutes: 2)));
}
