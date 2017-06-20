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
library webdriver.window_test;

import 'dart:math' show Point, Rectangle;

import 'package:test/test.dart';
import 'package:webdriver/sync_core.dart';

import 'sync_io_config.dart' as config;

void runTests(config.createTestDriver createTestDriver) {
  group('Window', () {
    WebDriver driver;

    setUp(() {
      driver = createTestDriver();
    });

    tearDown(() {
      if (driver != null) {
        driver.quit();
      }
      driver = null;
    });

    test('size', () {
      var window = driver.window;
      var windowRect = const Rectangle<int>(0, 0, 600, 400);
      window.rect = windowRect;
      // Height and width seem consistent across browser/platforms.
      expect(window.rect.width, windowRect.width);
      expect(window.rect.height, windowRect.height);

      // These are not consistent, so we give them a bit of wiggle.
      expect((window.rect.left - windowRect.left).abs(), lessThan(50));
      expect((window.rect.top - windowRect.top).abs(), lessThan(50));
    });

    // May not work on some OS/browser combinations (notably Mac OS X).
    test('maximize', () {
      var window = driver.window;
      final windowRect = const Rectangle<int>(100, 200, 300, 300);
      window.rect = windowRect;
      window.maximize();

      var finalRect = window.rect;
      expect(finalRect.width, greaterThan(300));
      expect(finalRect.height, greaterThan(300));
    }, skip: 'Unreliable on Travis');
  }, timeout: new Timeout(new Duration(minutes: 2)));
}
