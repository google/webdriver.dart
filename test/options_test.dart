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

library webdriver.options_test;

import 'package:test/test.dart';
import 'package:webdriver/async_core.dart';

import 'test_util.dart';

void main() {
  group('Cookies', () {
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

    test('add simple cookie', () async {
      await driver.cookies.add(new Cookie('mycookie', 'myvalue'));

      bool found = false;
      await for (var cookie in driver.cookies.all) {
        if (cookie.name == 'mycookie') {
          found = true;
          expect(cookie.value, 'myvalue');
          break;
        }
      }
      expect(found, isTrue);
    });

    test('add complex cookie', () async {
      var date = new DateTime.utc(2020);
      await driver.cookies.add(new Cookie('mycookie', 'myvalue',
          path: '/', domain: '.google.com', secure: false, expiry: date));
      bool found = false;
      await for (var cookie in driver.cookies.all) {
        if (cookie.name == 'mycookie') {
          found = true;
          expect(cookie.value, 'myvalue');
          expect(cookie.expiry, date);
          break;
        }
      }
      expect(found, isTrue);
    });

    test('delete cookie', () async {
      await driver.cookies.add(new Cookie('mycookie', 'myvalue'));
      await driver.cookies.delete('mycookie');
      bool found = false;
      await for (var cookie in driver.cookies.all) {
        if (cookie.name == 'mycookie') {
          found = true;
          break;
        }
      }
      expect(found, isFalse);
    });

    test('delete all cookies', () async {
      await driver.cookies.deleteAll();
      expect(await driver.cookies.all.toList(), isEmpty);
    });
  });

  group('TimeOuts', () {
    WebDriver driver;

    setUp(() async {
      driver = await createTestDriver();
    });

    tearDown(() async {
      if (driver != null) {
        await driver.quit();
      }
      driver = null;
    });

    // TODO(DrMarcII): Figure out how to tell if timeouts are correctly set
    test('set all timeouts', () async {
      await driver.timeouts.setScriptTimeout(new Duration(seconds: 5));
      await driver.timeouts.setImplicitTimeout(new Duration(seconds: 1));
      await driver.timeouts.setPageLoadTimeout(new Duration(seconds: 10));
    });
  });
}
