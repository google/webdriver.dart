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
library webdriver.command_event_test;

import 'package:stack_trace/stack_trace.dart';
import 'package:test/test.dart';
import 'package:webdriver/sync_core.dart';

import '../configs/sync_io_config.dart' as config;

void runTests({WebDriverSpec spec = WebDriverSpec.Auto}) {
  group('CommandEvent', () {
    WebDriver driver;

    var events = <WebDriverCommandEvent>[];

    setUp(() {
      driver = config.createTestDriver(spec: spec);
      driver.addEventListener(events.add);
      driver.get(config.testPagePath);
    });

    tearDown(() {
      driver.quit();
      events.clear();
      driver = null;
    });

    test('handles exceptions', () {
      try {
        driver.switchTo.alert.text;
        fail('Expected exception on no alert');
      } catch (NoSuchAlertException) {}
      expect(events[1].method, 'GET');
      expect(events[1].endPoint, contains('alert'));
      expect(events[1].exception, const isInstanceOf<WebDriverException>());
      expect(events[1].result, isNull);
      expect(events[1].startTime.isBefore(events[1].endTime), isTrue);
      expect(events[1].stackTrace, const isInstanceOf<Chain>());
    });

    test('handles normal operation', () {
      driver.findElements(const By.cssSelector('nosuchelement')).toList();
      expect(events[1].method, 'POST');
      expect(events[1].endPoint, contains('elements'));
      expect(events[1].exception, isNull);
      expect(events[1].result, isNotNull);
      expect(events[1].startTime.isBefore(events[1].endTime), isTrue);
      expect(events[1].stackTrace, const TypeMatcher<Chain>());
    });
  }, timeout: const Timeout(Duration(minutes: 2)));
}
