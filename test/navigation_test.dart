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

library webdriver.navigation_test;

import 'package:test/test.dart';
import 'package:webdriver/support/async.dart';
import 'package:webdriver/core.dart';

import 'test_util.dart';

void main() {
  group('Navigation', () {
    WebDriver driver;

    setUp(() async {
      driver = await createTestDriver();
      await driver.get('http://www.google.com/ncr');
    });

    tearDown(() async {
      if (driver != null) {
        await driver.quit();
      }
      driver = null;
    });

    test('refresh', () async {
      var element = await driver.findElement(const By.name('q'));
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
