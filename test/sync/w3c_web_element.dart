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
library webdriver.web_element_test;

import 'dart:io';

import 'package:test/test.dart';
import 'package:webdriver/sync_core.dart';
import 'package:webdriver/src/sync/w3c_spec/exception.dart';

import 'sync_io_config.dart' as config;

/// Tests specific to the W3C spec for WebElement. There are significant
/// differences between the JSON and W3C specs here.
void runTests(config.createTestDriver createTestDriver) {
  group('WebElement', () {
    WebDriver driver;
    WebElement table;
    WebElement button;
    WebElement form;
    WebElement textInput;
    WebElement checkbox;
    WebElement disabled;
    WebElement invisible;

    setUp(() {
      driver = createTestDriver();
      driver.get(config.testPagePath);
      table = driver.findElement(const By.tagName('table'));
      button = driver.findElement(const By.tagName('button'));
      form = driver.findElement(const By.tagName('form'));
      textInput = driver.findElement(const By.cssSelector('input[type=text]'));
      checkbox =
          driver.findElement(const By.cssSelector('input[type=checkbox]'));
      disabled =
          driver.findElement(const By.cssSelector('input[type=password]'));
      invisible = driver.findElement(const By.tagName('div'));
    });

    tearDown(() {
      if (driver != null) {
        driver.quit();
      }
      driver = null;
    });

    test('click', () {
      button.click();
      var alert = driver.switchTo.alert;
      alert.accept();
    });

    test('sendKeys', () {
      textInput.sendKeys('some keys');
      sleep(new Duration(milliseconds: 500));
      expect(textInput.properties['value'], 'some keys');
    });

    test('clear', () {
      textInput.sendKeys('some keys');
      textInput.clear();
      expect(textInput.properties['value'], '');
    });

    test('enabled', () {
      expect(table.enabled, isTrue);
      expect(button.enabled, isTrue);
      expect(form.enabled, isTrue);
      expect(textInput.enabled, isTrue);
      expect(checkbox.enabled, isTrue);
      expect(disabled.enabled, isFalse);
    });

    test('displayed', () {
      expect(table.displayed, isTrue);
      expect(button.displayed, isTrue);
      expect(form.displayed, isTrue);
      expect(textInput.displayed, isTrue);
      expect(checkbox.displayed, isTrue);
      expect(disabled.displayed, isTrue);
      expect(invisible.displayed, isFalse);
    });

    test('rect -- table', () {
      var location = table.rect;
      expect(location, config.isRectangle);
      expect(location.left, isNonNegative);
      expect(location.top, isNonNegative);
      expect(location.width, isNonNegative);
      expect(location.height, isNonNegative);
    });

    test('location -- invisible', () {
      var location = invisible.rect;
      expect(location, config.isRectangle);
      expect(location.left, 0);
      expect(location.top, 0);
      expect(location.width, 0);
      expect(location.height, 0);
    });

    test('name', () {
      expect(table.name, 'table');
      expect(button.name, 'button');
      expect(form.name, 'form');
      expect(textInput.name, 'input');
    });

    test('text', () {
      expect(table.text, 'r1c1 r1c2\nr2c1 r2c2');
      expect(button.text, 'button');
      expect(invisible.text, '');
    });

    test('findElement -- success', () {
      var element = table.findElement(const By.tagName('tr'));
      expect(element, config.isSyncWebElement);
    });

    test('findElement -- failure', () {
      try {
        button.findElement(const By.tagName('tr'));
        throw 'Expected Exception';
      } catch (e) {
        expect(e, new isInstanceOf<W3cWebDriverException>());
        expect((e as W3cWebDriverException).httpStatusCode, 404);
        expect((e as W3cWebDriverException).error, 'no such element');
        expect((e as W3cWebDriverException).message,
            contains('Unable to locate element'));
      }
    });

    test('findElements -- 1 found', () {
      var elements =
          form.findElements(const By.cssSelector('input[type=text]')).toList();
      expect(elements, hasLength(1));
      expect(elements, everyElement(config.isSyncWebElement));
    });

    test('findElements -- 4 found', () {
      var elements = table.findElements(const By.tagName('td')).toList();
      expect(elements, hasLength(4));
      expect(elements, everyElement(config.isSyncWebElement));
    });

    test('findElements -- 0 found', () {
      var elements = form.findElements(const By.tagName('td')).toList();
      expect(elements, isEmpty);
    });

    test('attributes', () {
      expect(table.attributes['id'], 'table1');
      expect(table.attributes['non-standard'], 'a non standard attr');
      expect(table.attributes['disabled'], isNull);
      expect(disabled.attributes['disabled'], 'true');
    });

    test('cssProperties', () {
      expect(invisible.cssProperties['display'], 'none');
      final backgroundColor = invisible.cssProperties['background-color'];
      expect(backgroundColor, contains('255, 0, 0'));
      expect(backgroundColor, startsWith('rgb'));
      expect(invisible.cssProperties['direction'], 'ltr');
    });

    test('equals', () {
      expect(invisible.equals(disabled), isFalse);
      var element = driver.findElement(const By.cssSelector('table'));
      expect(element.equals(table), isTrue);
    });
  }, timeout: new Timeout(new Duration(minutes: 2)));
}
