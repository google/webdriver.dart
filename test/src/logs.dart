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

library webdriver.logs_test;

import 'package:test/test.dart';
import 'package:webdriver/core.dart';

import '../test_util.dart';

void runTests() {
  group('Logs', () {
    WebDriver driver;

    setUp(() async {
      Map capabilities = {
        Capabilities.loggingPrefs: {LogType.performance: LogLevel.info}
      };

      driver = await createTestDriver(additionalCapabilities: capabilities);
      await driver.get('http://www.google.com/ncr');
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
