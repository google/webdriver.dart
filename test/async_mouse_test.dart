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
library webdriver.mouse_test;

import 'dart:io';

import 'package:test/test.dart';
import 'package:webdriver/async_core.dart';

import 'configs/async_io_config.dart' as config;

void main() {
  group('Mouse', () {
    WebDriver driver;
    WebElement button;
    HttpServer server;

    setUp(() async {
      driver = await config.createTestDriver();
      server = await config.createTestServerAndGoToTestPage(driver);
      button = await driver.findElement(const By.tagName('button'));
    });

    tearDown(() async {
      await driver?.quit();
      await server?.close(force: true);
    });

    test('moveTo element/click', () async {
      await driver.mouse.moveTo(element: button);
      await driver.mouse.click();
      var alert = await driver.switchTo.alert;
      await alert.dismiss();
    });

    test('moveTo coordinates/click', () async {
      var pos = await button.location;
      await driver.mouse.moveTo(xOffset: pos.x + 5, yOffset: pos.y + 5);
      await driver.mouse.click();
      var alert = await driver.switchTo.alert;
      await alert.dismiss();
    });

    test('moveTo element coordinates/click', () async {
      await driver.mouse.moveTo(element: button, xOffset: 5, yOffset: 5);
      await driver.mouse.click();
      var alert = await driver.switchTo.alert;
      await alert.dismiss();
    });

    // TODO(DrMarcII): Better up/down tests
    test('down/up', () async {
      await driver.mouse.moveTo(element: button);
      await driver.mouse.down();
      await driver.mouse.up();
      var alert = await driver.switchTo.alert;
      await alert.dismiss();
    });

    // TODO(DrMarcII): Better double click test
    test('doubleClick', () async {
      await driver.mouse.moveTo(element: button);
      await driver.mouse.doubleClick();
      var alert = await driver.switchTo.alert;
      await alert.dismiss();
    });
  }, timeout: const Timeout(Duration(minutes: 2)));
}
