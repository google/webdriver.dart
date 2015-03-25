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

library webdriver.keyboard_test;

import 'package:unittest/unittest.dart';
import 'package:webdriver/core.dart';

import '../test_util.dart';

void main() {
  group('Keyboard', () {
    WebDriver driver;
    WebElement textInput;

    setUp(() async {
      driver = await createTestDriver();
      await driver.navigate.to(testPagePath);
      textInput =
          await driver.findElement(const By.cssSelector('input[type=text]'));
      await textInput.click();
    });

    tearDown(() => driver.quit());

    test('sendKeys -- once', () async {
      await driver.keyboard.sendKeys('abcdef');
      expect(await textInput.attributes['value'], 'abcdef');
    });

    test('sendKeys -- twice', () async {
      await driver.keyboard.sendKeys('abc');
      await driver.keyboard.sendKeys('def');
      expect(await textInput.attributes['value'], 'abcdef');
    });

    test('sendKeys -- with tab', () async {
      await driver.keyboard.sendKeys('abc${Keyboard.tab}def');
      expect(await textInput.attributes['value'], 'abc');
    });
  });
}
