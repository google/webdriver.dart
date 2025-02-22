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
library;

import 'dart:io';

import 'package:test/test.dart';
import 'package:webdriver/async_core.dart';

import 'configs/async_io_config.dart' as config;

void main() {
  group('Keyboard', () {
    late WebDriver driver;
    late WebElement textInput;
    var ctrlCmdKey = '';

    setUp(() async {
      if (Platform.isMacOS) {
        ctrlCmdKey = Keyboard.command;
      } else {
        ctrlCmdKey = Keyboard.control;
      }

      driver = await config.createTestDriver();
      await config.createTestServerAndGoToTestPage(driver);

      textInput =
          await driver.findElement(const By.cssSelector('input[type=text]'));
      await textInput.click();
    });

    test('sendKeys -- once', () async {
      await driver.keyboard.sendKeys('abcdef');
      expect(await textInput.properties['value'], 'abcdef');
    });

    test('sendKeys -- twice', () async {
      await driver.keyboard.sendKeys('abc');
      await driver.keyboard.sendKeys('def');
      expect(await textInput.properties['value'], 'abcdef');
    });

    test('sendKeys -- with tab', () async {
      await driver.keyboard.sendKeys('abc${Keyboard.tab}def');
      expect(await textInput.properties['value'], 'abc');
    });

    // NOTE: does not work on Mac.
    test('sendChord -- CTRL+X', () async {
      await driver.keyboard.sendKeys('abcdef');
      expect(await textInput.properties['value'], 'abcdef');
      await driver.keyboard.sendChord([ctrlCmdKey, 'a']);
      await driver.keyboard.sendChord([ctrlCmdKey, 'x']);
      await driver.keyboard.sendKeys('xxx');
      expect(await textInput.properties['value'], 'xxx');
    });
  }, timeout: const Timeout(Duration(minutes: 2)));
}
