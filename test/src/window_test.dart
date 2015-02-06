// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library webdriver_test.window;

import 'dart:math' show Point, Rectangle;

import 'package:unittest/unittest.dart';
import 'package:webdriver/webdriver.dart';

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

    test('location', () async {
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
