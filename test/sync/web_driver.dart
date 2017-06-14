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
library webdriver.web_driver_test;

import 'package:test/test.dart';
import 'package:webdriver/sync_core.dart';

import 'sync_io_config.dart' as config;

void runTests(config.createTestDriver createTestDriver) {
  group('WebDriver', () {
    group('create', () {
      test('default', () {
        WebDriver driver = createTestDriver();
        driver.get(config.testPagePath);
        var element = driver.findElement(const By.tagName('button'));
        expect(element.name, 'button');
        driver.quit();
      });
    });

    /*group('methods', () {
      WebDriver driver;

      setUp(() {
        driver = createTestDriver();
        driver.get(config.testPagePath);
      });

      tearDown(() {
        if (driver != null) {
          driver.quit();
        }
        driver = null;
      });

      test('get', () {
        driver.get(config.testPagePath);
        driver.findElement(const By.tagName('button'));
        ;
      });

      test('currentUrl', () {
        var url = driver.currentUrl;
        expect(url, anyOf(startsWith('file:'), startsWith('http:')));
        expect(url, endsWith('test_page.html'));
      });

      test('findElement -- success', () {
        var element = driver.findElement(const By.tagName('tr'));
        expect(element, config.isSyncWebElement);
      });

      test('findElement -- failure', () {
        try {
          driver.findElement(const By.id('non-existent-id'));
          throw 'expected NoSuchElementException';
        } on NoSuchElementException {}
      });

      test('findElements -- 1 found', () {
        var elements = driver
            .findElements(const By.cssSelector('input[type=text]'))
            .toList();
        expect(elements, hasLength(1));
        expect(elements, everyElement(config.isSyncWebElement));
      });

      test('findElements -- 4 found', () {
        var elements = driver.findElements(const By.tagName('td')).toList();
        expect(elements, hasLength(4));
        expect(elements, everyElement(config.isSyncWebElement));
      });

      test('findElements -- 0 found', () {
        var elements =
            driver.findElements(const By.id('non-existent-id')).toList();
        expect(elements, isEmpty);
      });

      test('pageSource', () {
        expect(driver.pageSource, contains('<title>test_page</title>'));
      });

      test('close/windows', () {
        int numHandles = (driver.windows.toList()).length;
        (driver.findElement(const By.partialLinkText('Open copy'))).click();
        expect(driver.windows.toList(), hasLength(numHandles + 1));
        driver.close();
        expect(driver.windows.toList(), hasLength(numHandles));
      });

      test('window', () {
        Window orig = driver.window;
        Window next;

        (driver.findElement(const By.partialLinkText('Open copy'))).click();
        for (Window window in driver.windows) {
          if (window != orig) {
            next = window;
            driver.switchTo.window(window);
            break;
          }
        }
        expect(driver.window, equals(next));
        driver.close();
      });

      test('activeElement', () {
        var element = driver.activeElement;
        expect(element.name, 'body');
        (driver.findElement(const By.cssSelector('input[type=text]'))).click();
        element = driver.activeElement;
        expect(element.name, 'input');
      });

      test('windows', () {
        var windows = driver.windows.toList();
        expect(windows, hasLength(isPositive));
        expect(windows, everyElement(new isInstanceOf<Window>()));
      });

      test('execute', () {
        WebElement button = driver.findElement(const By.tagName('button'));
        String script = '''
            arguments[1].textContent = arguments[0];
            return arguments[1];''';
        var e = driver.execute(script, ['new text', button]);
        expect(e.text, 'new text');
      });

      test('executeAsync', () {
        WebElement button = driver.findElement(const By.tagName('button'));
        String script = '''
            arguments[1].textContent = arguments[0];
            arguments[2](arguments[1]);''';
        var e = driver.executeAsync(script, ['new text', button]);
        expect(e.text, 'new text');
      });

      test('captureScreenshot', () {
        var screenshot = driver.captureScreenshotAsList().toList();
        expect(screenshot, hasLength(isPositive));
        expect(screenshot, everyElement(new isInstanceOf<int>()));
      });

      test('captureScreenshotAsList', () {
        var screenshot = driver.captureScreenshotAsList();
        expect(screenshot, hasLength(isPositive));
        expect(screenshot, everyElement(new isInstanceOf<int>()));
      });

      test('captureScreenshotAsBase64', () {
        var screenshot = driver.captureScreenshotAsBase64();
        expect(screenshot, hasLength(isPositive));
        expect(screenshot, new isInstanceOf<String>());
      });

      test('event listeners work with script timeouts', () {
        try {
          driver.timeouts.setScriptTimeout(new Duration(seconds: 1));
          driver.executeAsync('', []);
          fail('Did not throw timeout as expected');
        } catch (e) {
          expect(e.toString(), contains('asynchronous script timeout'));
        }
      });

      test('event listeners ordered appropriately', () {
        var eventList = new List<int>();
        int current = 0;
        driver.addEventListener((WebDriverCommandEvent e) {
          eventList.add(current++);
        });

        for (int i = 0; i < 10; i++) {
          driver.title; // GET request.
        }
        expect(eventList, hasLength(10));
        for (int i = 0; i < 10; i++) {
          expect(eventList[i], i);
        }
      });
    });*/
  }, timeout: new Timeout(new Duration(minutes: 1)));
}
