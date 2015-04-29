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

@TestOn('browser')
library webdriver.html_test;

import 'dart:html' as html;

import 'package:test/test.dart';
import 'package:webdriver/html.dart'
    show WebDriver, Capabilities, createDriver, fromExistingSession;

import 'src/alert_test.dart' as alert;
import 'src/keyboard_test.dart' as keyboard;
import 'src/logs_test.dart' as logs;
import 'src/mouse_test.dart' as mouse;
import 'src/navigation_test.dart' as navigation;
import 'src/options_test.dart' as options;
import 'src/target_locator_test.dart' as target_locator;
import 'src/web_driver_test.dart' as web_driver;
import 'src/web_element_test.dart' as web_element;
import 'src/window_test.dart' as window;
import 'test_util.dart' as test_util;

void main() {
  test_util.runningOnTravis = false;
  test_util.createTestDriver = ({Map additionalCapabilities}) {
    Map capabilities = Capabilities.chrome;

    if (additionalCapabilities != null) {
      capabilities.addAll(additionalCapabilities);
    }

    return createDriver(desired: capabilities);
  };

  test_util.testPagePath =
      Uri.parse(html.window.location.href).resolve('test_page.html').toString();

  group('html-specific tests', () {
    WebDriver driver;
    setUp(() async {
      driver = await test_util.createTestDriver();
      await driver.get(test_util.testPagePath);
    });

    tearDown(() => driver.quit());

    test('fromExistingSession', () async {
      WebDriver newDriver =
          await fromExistingSession(driver.id, uri: driver.uri);
      expect(newDriver.capabilities, driver.capabilities);
      var url = await newDriver.currentUrl;
      expect(url, startsWith('http:'));
      expect(url, endsWith('test_page.html'));
      await newDriver.get('http://www.google.com/ncr');
      url = await driver.currentUrl;
      expect(url, contains('www.google.com'));
    });
  });

  alert.runTests();
  keyboard.runTests();
  logs.runTests();
  mouse.runTests();
  navigation.runTests();
  options.runTests();
  target_locator.runTests();
  web_driver.runTests();
  web_element.runTests();
  window.runTests();
}
