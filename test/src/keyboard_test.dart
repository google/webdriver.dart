// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library webdriver_test.keyboard;

import 'package:unittest/unittest.dart';
import 'package:webdriver/webdriver.dart';

import '../test_util.dart';

void main() {
  group('Keyboard', () {
    WebDriver driver;
    WebElement textInput;

    setUp(() async {
      driver = await createTestDriver();
      await driver.get(testPagePath);
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
