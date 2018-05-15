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
library webdriver.keyboard_test;

import 'dart:io';

import 'package:test/test.dart';
import 'package:webdriver/sync_core.dart';

import 'sync_io_config.dart' as config;

void runTests(config.createTestDriver createTestDriver) {
  group('Keyboard', () {
    WebDriver driver;
    WebElement textInput;
    String ctrlCmdKey = '';

    setUp(() {
      if (Platform.isMacOS) {
        ctrlCmdKey = Keyboard.command;
      } else {
        ctrlCmdKey = Keyboard.control;
      }

      driver = createTestDriver();
      driver.get(config.testPagePath);
      textInput = driver.findElement(const By.cssSelector('input[type=text]'));
      textInput.click();
    });

    tearDown(() {
      if (driver != null) {
        driver.quit();
      }
      driver = null;
    });

    test('sendKeys -- once', () {
      driver.keyboard.sendKeys('abcdef');
      expect(valueOf(textInput), 'abcdef');
    });

    test('sendKeys -- twice', () {
      driver.keyboard.sendKeys('abc');
      driver.keyboard.sendKeys('def');
      expect(valueOf(textInput), 'abcdef');
    });

    test('sendKeys -- with tab', () {
      driver.keyboard.sendKeys('abc${Keyboard.tab}def');
      expect(valueOf(textInput), 'abc');
    });

    // NOTE: does not work on Mac.
    test('sendChord -- CTRL+X', () {
      driver.keyboard.sendKeys('abcdef');
      expect(valueOf(textInput), 'abcdef');
      driver.keyboard.sendChord([ctrlCmdKey, 'a']);
      driver.keyboard.sendChord([ctrlCmdKey, 'x']);
      driver.keyboard.sendKeys('xxx');
      expect(valueOf(textInput), 'xxx');
    });
  }, timeout: const Timeout(const Duration(minutes: 2)));
}

/// Gets the "value" property of a [WebElement].
///
/// The behavior for the "value" property of a text input is different for
/// different specs (json wire updates it through attribute and W3C updates it
/// through property).
String valueOf(WebElement textInput) {
  return textInput.attributes['value'] ?? textInput.properties['value'];
}