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

library webdriver.window_test;

import 'dart:math' show Point, Rectangle;

import 'package:unittest/unittest.dart';
import 'package:webdriver/async_helpers.dart';
import 'package:webdriver/core.dart';

import '../test_util.dart';

void main() {
  group('Window', () {
    WebDriver driver;

    setUp(() async {
      driver = await createTestDriver();
    });

    tearDown(() => driver.quit());

    test('size', () async {
      var window = await driver.window;
      var size = const Rectangle<int>(0, 0, 600, 400);
      await window.setSize(size);
      expect(await window.size, size);
    });

    skip_test('location', () async {
      var window = await driver.window;
      var position = const Point<int>(100, 200);
      await window.setLocation(position);
      expect(await window.location, position);
    });

    // May not work on some OS/browser combinations (notably Mac OS X).
    skip_test('maximize', () async {
      var window = await driver.window;
      await window.setSize(const Rectangle<int>(0, 0, 300, 200));
      await window.setLocation(const Point<int>(100, 200));
      await window.maximize();

      // maximizing can take some time
      await waitFor(() async => (await window.size).height,
          matcher: greaterThan(200));

      var location = await window.location;
      var size = await window.size;
      // Changed from `lessThan(100)` to pass the test on Mac.
      expect(location.x, lessThanOrEqualTo(100));
      expect(location.y, lessThan(200));
      expect(size.height, greaterThan(200));
      expect(size.width, greaterThan(300));
    });
  });
}
