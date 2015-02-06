// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library webdriver_test.logs;

import 'package:unittest/unittest.dart';
import 'package:webdriver/webdriver.dart';

import '../test_util.dart';

void main() {
  group('Logs', () {
    WebDriver driver;

    setUp(() async {
      Map capabilities = {
        Capabilities.loggingPrefs: {LogType.performance: LogLevel.info}
      };

      driver = await createTestDriver(additionalCapabilities: capabilities);
      await driver.get('http://www.google.com');
    });

    tearDown(() => driver.quit());

    test('get logs', () async {
      List<LogEntry> logs = await driver.logs.get(LogType.performance).toList();
      expect(logs.length, greaterThan(0));
      logs.forEach((entry) {
        expect(entry.level, equals(LogLevel.info));
      });
    });
  });
}
