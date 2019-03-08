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
library webdriver.logs_test;

import 'dart:io';

import 'package:test/test.dart';
import 'package:webdriver/async_core.dart';

import 'configs/async_io_config.dart' as config;

void main() {
  group('Logs', () {
    WebDriver driver;
    HttpServer server;

    setUp(() async {
      Map<String, dynamic> capabilities = {
        Capabilities.loggingPrefs: {LogType.performance: LogLevel.info}
      };

      driver =
          await config.createTestDriver(additionalCapabilities: capabilities);
      server = await config.createTestServerAndGoToTestPage(driver);
    });

    tearDown(() async {
      await driver?.quit();
      await server?.close(force: true);
    });

    test('get logs', () async {
      List<LogEntry> logs = await driver.logs.get(LogType.performance).toList();
      expect(logs.length, greaterThan(0));
      logs.forEach((entry) {
        expect(entry.level, equals(LogLevel.info));
      });
    });
  }, timeout: const Timeout(Duration(minutes: 2)));
}
