// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library webdriver_test.web_driver;

import 'package:unittest/unittest.dart';
import 'package:webdriver/webdriver.dart';

import '../test_util.dart';

void main() {
  group('WebDriver', () {
    group('create', () {
      test('default', () async {
        WebDriver driver = await createTestDriver();
        await driver.get('http://www.google.com');
        var element = await driver.findElement(new By.name('q'));
        expect(await element.name, 'input');
        await driver.quit();
      });

      test('chrome', () async {
        WebDriver driver = await createTestDriver();
        await driver.get('http://www.google.com');
        var element = await driver.findElement(new By.name('q'));
        expect(await element.name, 'input');
        await driver.quit();
      });

      test('firefox', () async {
        // Avoid this test on the bot; currently we just test against chromedriver.
        if (isRunningOnTravis()) return;

        WebDriver driver = await WebDriver.createDriver(
            desiredCapabilities: Capabilities.firefox);
        await driver.get('http://www.google.com');
        var element = await driver.findElement(new By.name('q'));
        expect(await element.name, 'input');
        await driver.quit();
      });
    });

    group('methods', () {
      WebDriver driver;

      setUp(() async {
        driver = await createTestDriver();
        await driver.get(testPagePath);
      });

      tearDown(() => driver.quit());

      test('get', () async {
        await driver.get('http://www.google.com');
        await driver.findElement(new By.name('q'));
        await driver.get('http://www.yahoo.com');
        await driver.findElement(new By.name('p'));
      });

      test('currentUrl', () async {
        var url = await driver.currentUrl;
        expect(url, startsWith('file:'));
        expect(url, endsWith('test_page.html'));
        await driver.get('http://www.google.com');
        url = await driver.currentUrl;
        expect(url, contains('www.google.com'));
      });

      test('findElement -- success', () async {
        var element = await driver.findElement(new By.tagName('tr'));
        expect(element, isWebElement);
      });

      test('findElement -- failure', () async {
        try {
          await driver.findElement(new By.id('non-existent-id'));
          throw 'expected NoSuchElementException';
        } on NoSuchElementException {}
      });

      test('findElements -- 1 found', () async {
        var elements = await driver
            .findElements(new By.cssSelector('input[type=text]'))
            .toList();
        expect(elements, hasLength(1));
        expect(elements, everyElement(isWebElement));
      });

      test('findElements -- 4 found', () async {
        var elements = await driver.findElements(new By.tagName('td')).toList();
        expect(elements, hasLength(4));
        expect(elements, everyElement(isWebElement));
      });

      test('findElements -- 0 found', () async {
        var elements =
            await driver.findElements(new By.id('non-existent-id')).toList();
        expect(elements, isEmpty);
      });

      test('pageSource', () async {
        expect(await driver.pageSource, contains('<title>test_page</title>'));
      });

      test('close/windows', () async {
        int numHandles = (await driver.windows.toList()).length;
        await (await driver.findElement(new By.partialLinkText('Open copy')))
            .click();
        expect(await driver.windows.toList(), hasLength(numHandles + 1));
        await driver.close();
        expect(await driver.windows.toList(), hasLength(numHandles));
      });

      test('window', () async {
        Window orig = await driver.window;
        Window next;

        await (await driver.findElement(new By.partialLinkText('Open copy')))
            .click();
        await for (Window window in driver.windows) {
          if (window != orig) {
            next = window;
            await driver.switchTo.window(window);
            break;
          }
        }
        expect(await driver.window, equals(next));
        await driver.close();
      });

      test('activeElement', () async {
        var element = await driver.activeElement;
        expect(await element.name, 'body');
        await (await driver.findElement(new By.cssSelector('input[type=text]')))
            .click();
        element = await driver.activeElement;
        expect(await element.name, 'input');
      });

      test('windows', () async {
        var windows = await driver.windows.toList();
        expect(windows, hasLength(isPositive));
        expect(windows, everyElement(new isInstanceOf<Window>()));
      });

      test('execute', () async {
        WebElement button = await driver.findElement(new By.tagName('button'));
        String script = '''
            arguments[1].textContent = arguments[0];
            return arguments[1];''';
        var e = await driver.execute(script, ['new text', button]);
        expect(await e.text, 'new text');
      });

      test('executeAsync', () async {
        WebElement button = await driver.findElement(new By.tagName('button'));
        String script = '''
            arguments[1].textContent = arguments[0];
            arguments[2](arguments[1]);''';
        var e = await driver.executeAsync(script, ['new text', button]);
        expect(await e.text, 'new text');
      });

      test('captureScreenshot', () async {
        var screenshot = await driver.captureScreenshot();
        expect(screenshot, hasLength(isPositive));
        expect(screenshot, everyElement(new isInstanceOf<int>()));
      });
    });
  });
}
