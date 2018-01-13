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
library webdriver.target_locator_test;

import 'package:test/test.dart';
import 'package:webdriver/sync_core.dart';

import 'sync_io_config.dart' as config;

/// Tests for switchTo.frame(). switchTo.window() and switchTo.alert are tested
/// in other classes.
void runTests(config.createTestDriver createTestDriver) {
  group('TargetLocator', () {
    WebDriver driver;
    WebElement frame;

    setUp(() {
      driver = createTestDriver();
      driver.get(config.testPagePath);
      frame = driver.findElement(const By.name('frame'));
    });

    tearDown(() {
      if (driver != null) {
        driver.quit();
      }
      driver = null;
    });

    test('frame index', () {
      driver.switchTo.frame(0);
      expect(driver.pageSource, contains('this is a frame'));
    });

    // Both the JSON and W3C specs allow passing strings. In the JSON spec, we
    // expect this to work (finds a frame with the name of the string). In the
    // W3C spec we expect this to fail with an exception thrown by the driver.
    test('frame name', () {
      try {
        driver.switchTo.frame('frame');
        print('FINISHED SWITCH');
        expect(driver.pageSource, contains('this is a frame')); // JSON.
      } on Exception catch (e) {
        expect(e.toString(), contains('frame id has unexpected type')); // W3C.
      }
    });

    test('frame element', () {
      driver.switchTo.frame(frame);
      expect(driver.pageSource, contains('this is a frame'));
    });

    test('root frame', () {
      driver.switchTo.frame(frame);
      driver.switchTo.frame();
      driver.findElement(const By.tagName('button'));
    });
  }, timeout: const Timeout(const Duration(minutes: 2)));
}
