// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library webdriver_test.navigation;

import 'package:unittest/unittest.dart';
import 'package:webdriver/webdriver.dart';

import '../test_util.dart';

void main() {
  group('Navigation', () {
    WebDriver driver;

    setUp(() async {
      driver = await createTestDriver();
      await driver.get('http://www.google.com/ncr');
    });

    tearDown(() => driver.quit());

    test('forward/back', () async {
      await driver.get('http://www.yahoo.com');
      await driver.navigate.back();
      await waitFor(() => driver.title, matcher: contains('Google'));
      await driver.navigate.forward();
      await waitFor(() => driver.title, matcher: contains('Yahoo'));
    });

    test('refresh', () async {
      var element = await driver.findElement(new By.name('q'));
      await driver.navigate.refresh();
      await waitFor(() async {
        try {
          await element.name;
        } on StaleElementReferenceException {
          return true;
        }
        return 'expected StaleElementReferenceException';
      });
    });
  });
}
