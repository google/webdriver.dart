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
library webdriver.options_test;

import 'package:test/test.dart';
import 'package:webdriver/sync_core.dart';

import 'sync_io_config.dart' as config;

void main() {
  group('Cookies', () {
    WebDriver driver;

    setUp(() {
      driver = config.createTestDriver();
      driver.get('http://www.google.com/ncr');
    });

    tearDown(() {
      if (driver != null) {
        driver.quit();
      }
      driver = null;
    });

    test('add simple cookie', () {
      driver.cookies.add(new Cookie('mycookie', 'myvalue'));

      bool found = false;
      for (var cookie in driver.cookies.all) {
        if (cookie.name == 'mycookie') {
          found = true;
          expect(cookie.value, 'myvalue');
          break;
        }
      }
      expect(found, isTrue);
    });

    test('add complex cookie', () {
      var date = new DateTime.utc(2020);
      driver.cookies.add(new Cookie('mycookie', 'myvalue',
          path: '/', domain: '.google.com', secure: false, expiry: date));
      bool found = false;
      for (var cookie in driver.cookies.all) {
        if (cookie.name == 'mycookie') {
          found = true;
          expect(cookie.value, 'myvalue');
          expect(cookie.expiry, date);
          break;
        }
      }
      expect(found, isTrue);
    });

    test('delete cookie', () {
      driver.cookies.add(new Cookie('mycookie', 'myvalue'));
      driver.cookies.delete('mycookie');
      bool found = false;
      for (var cookie in driver.cookies.all) {
        if (cookie.name == 'mycookie') {
          found = true;
          break;
        }
      }
      expect(found, isFalse);
    });

    test('delete all cookies', () {
      driver.cookies.deleteAll();
      expect(driver.cookies.all.toList(), isEmpty);
    }, skip: 'unreliable');
  }, timeout: new Timeout(new Duration(minutes: 1)));
}
