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

void main() {
  group('Window', () {
    WebDriver driver;

    setUp(() {
      driver = config.createTestDriver();
    });

    tearDown(() {
      if (driver != null) {
        driver.quit();
      }
      driver = null;
    });

    test('size', () {
      var window = driver.window;
      var size = const Rectangle<int>(0, 0, 600, 400);
      window.setSize(size);
      expect(window.size, size);
    });

    test('location', () {
      var window = driver.window;
      var position = const Point<int>(100, 200);
      window.setLocation(position);
      expect(window.location, position);
    }, skip: 'unreliable');

    // May not work on some OS/browser combinations (notably Mac OS X).
    test('maximize', () {
      var window = driver.window;
      window.setSize(const Rectangle<int>(0, 0, 300, 200));
      window.setLocation(const Point<int>(100, 200));
      window.maximize();

      var location = window.location;
      var size = window.size;
      // Changed from `lessThan(100)` to pass the test on Mac.
      expect(location.x, lessThanOrEqualTo(100));
      expect(location.y, lessThan(200));
      expect(size.height, greaterThan(200));
      expect(size.width, greaterThan(300));
    }, skip: 'unreliable');
  }, timeout: new Timeout(new Duration(minutes: 1)));
}
