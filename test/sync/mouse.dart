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

@TestOn('vm')
library webdriver.mouse_test;

import 'package:test/test.dart';
import 'package:webdriver/sync_core.dart';

import 'sync_io_config.dart' as config;

void runTests(config.createTestDriver createTestDriver) {
  group('Mouse', () {
    WebDriver driver;
    WebElement button;

    setUp(() {
      driver = createTestDriver();
      driver.get(config.testPagePath);
      button = driver.findElement(const By.tagName('button'));
    });

    tearDown(() {
      if (driver != null) {
        driver.quit();
      }
      driver = null;
    });

    test('moveTo element/click', () {
      driver.mouse.moveTo(element: button);
      driver.mouse.click();
      var alert = driver.switchTo.alert;
      alert.dismiss();
    });

    test('moveTo coordinates/click', () {
      var pos = button.location;
      driver.mouse.moveTo(xOffset: pos.x + 5, yOffset: pos.y + 5);
      driver.mouse.click();
      var alert = driver.switchTo.alert;
      alert.dismiss();
    });

    test('moveTo element coordinates/click', () {
      driver.mouse.moveTo(element: button, xOffset: 5, yOffset: 5);
      driver.mouse.click();
      var alert = driver.switchTo.alert;
      alert.dismiss();
    });

    // TODO(DrMarcII): Better up/down tests
    test('down/up', () {
      driver.mouse.moveTo(element: button);
      driver.mouse.down();
      driver.mouse.up();
      var alert = driver.switchTo.alert;
      alert.dismiss();
    });

    // TODO(DrMarcII): Better double click test
    test('doubleClick', () {
      driver.mouse.moveTo(element: button);
      driver.mouse.doubleClick();
      var alert = driver.switchTo.alert;
      alert.dismiss();
    });
  }, timeout: const Timeout(const Duration(minutes: 2)));
}
