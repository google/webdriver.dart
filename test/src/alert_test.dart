// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library webdriver_test.alert;

import 'package:unittest/unittest.dart';
import 'package:webdriver/webdriver.dart';

import '../test_util.dart';

void main() {
  group('Alert', () {
    WebDriver driver;
    WebElement button;
    WebElement output;

    setUp(() async {
      driver = await createTestDriver();
      await driver.get(testPagePath);
      button = await driver.findElement(const By.tagName('button'));
      output = await driver.findElement(const By.id('settable'));
    });

    tearDown(() => driver.quit());

    test('no alert', () {
      expect(driver.switchTo.alert, throws);
    });

    test('text', () async {
      await button.click();
      var alert = await driver.switchTo.alert;
      expect(alert.text, 'button clicked');
      await alert.dismiss();
    });

    test('accept', () async {
      await button.click();
      var alert = await driver.switchTo.alert;
      await alert.accept();
      expect(await output.text, startsWith('accepted'));
    });

    test('dismiss', () async {
      await button.click();
      var alert = await driver.switchTo.alert;
      await alert.dismiss();
      expect(await output.text, startsWith('dismissed'));
    });

    test('sendKeys', () async {
      await button.click();
      Alert alert = await driver.switchTo.alert;
      await alert.sendKeys('some keys');
      await alert.accept();
      expect(await output.text, endsWith('some keys'));
    });
  });
}
