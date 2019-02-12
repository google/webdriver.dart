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

@TestOn('vm')
library webdriver.support.forwarder_test;

import 'dart:io';

import 'package:test/test.dart';
import 'package:webdriver/io.dart';
import 'package:webdriver/support/forwarder.dart';

import '../configs/async_io_config.dart' as config;

const buttonClicked = 'Button clicked';
const buttonNotClicked = 'Button not clicked';

void main() {
  group('WebDriverForwarder', () {
    WebDriver driver;
    WebDriverForwarder forwarder;
    HttpServer server;
    WebDriver forwardedDriver;
    Uri address;

    setUp(() async {
      driver = await config.createTestDriver();
      forwarder = WebDriverForwarder(driver, prefix: '/webdriver/session/1');

      server = await config.createLocalServer();
      server.listen((request) {
        if (request.uri.path.startsWith('/webdriver')) {
          forwarder.forward(request);
        } else if (request.method == 'GET' &&
            request.uri.path.endsWith('test_page.html')) {
          String testPagePath = config.forwarderTestPagePath;
          File file = File(testPagePath);
          request.response
            ..statusCode = HttpStatus.ok
            ..headers.set('Content-type', 'text/html');
          file.openRead().pipe(request.response);
        } else {
          request.response
            ..statusCode = HttpStatus.notFound
            ..close();
        }
      });
      address = Uri.http('localhost:${server.port}', '/webdriver/');
      forwardedDriver =
          fromExistingSessionSync('1', WebDriverSpec.JsonWire, uri: address);

      await forwardedDriver.get(address.resolve('/test_page.html'));
    });

    tearDown(() async {
      try {
        await forwardedDriver.quit();
      } catch (e) {
        print('Ignored error quitting forwardedDriver: $e');
      }
      try {
        await server.close(force: true);
      } catch (e) {
        print('Ignored error quitting server: $e');
      }
      try {
        await driver.quit();
      } catch (e) {
        print('Ignored error quitting driver: $e');
      }
    });

    test('get url', () async {
      expect(await forwardedDriver.currentUrl, endsWith('test_page.html'));
    });

    test('click button', () async {
      expect(await forwardedDriver.getRequest('element/div/text'),
          buttonNotClicked);

      await forwardedDriver.postRequest('element/button/click', {'button': 0});
      expect(
          await forwardedDriver.getRequest('element/div/text'), buttonClicked);
    });

    test('moveto/click', () async {
      expect(await forwardedDriver.getRequest('element/div/text'),
          buttonNotClicked);

      await forwardedDriver.postRequest('moveto', {'element': 'button'});
      await forwardedDriver.mouse.click();

      expect(
          await forwardedDriver.getRequest('element/div/text'), buttonClicked);
    });

    test('execute_script', () async {
      expect(await forwardedDriver.getRequest('element/div/text'),
          buttonNotClicked);

      await forwardedDriver.execute('arguments[0].el.click();', [
        {
          'el': {'ELEMENT': 'button'}
        }
      ]);

      expect(
          await forwardedDriver.getRequest('element/div/text'), buttonClicked);
    });

    test('element equals', () async {
      expect(
          await forwardedDriver.getRequest('element/div/equals/div'), isTrue);
      expect(await forwardedDriver.getRequest('element/div/equals/button'),
          isFalse);
    });

    // TODO(DrMarcII) add test that actually uses shadow dom
    test('enable/disable deep', () async {
      await forwardedDriver.postRequest('disabledeep');

      expect(await forwardedDriver.getRequest('element/div/text'),
          buttonNotClicked);

      await forwardedDriver.postRequest('element/button/click', {'button': 0});
      expect(
          await forwardedDriver.getRequest('element/div/text'), buttonClicked);

      await forwardedDriver.postRequest('enabledeep');
      await forwardedDriver.refresh();

      expect(await forwardedDriver.getRequest('element/div/text'),
          buttonNotClicked);

      await forwardedDriver.postRequest('element/button/click', {'button': 0});
      expect(
          await forwardedDriver.getRequest('element/div/text'), buttonClicked);
    });

    test('window close', () async {
      await (await forwardedDriver.window).close();
    });
  }, timeout: const Timeout(Duration(minutes: 2)));
}
