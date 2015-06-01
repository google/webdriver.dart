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

library webdriver.command_event_test;

import 'package:stack_trace/stack_trace.dart';
import 'package:test/test.dart';
import 'package:webdriver/core.dart';
import 'package:webdriver/support/async.dart';

import '../test_util.dart';

void runTests() {
  group('CommandEvent', () {
    WebDriver driver;

    var events = [];
    var sub;

    setUp(() async {
      driver = await createTestDriver();
      sub = driver.onAfterCommand.listen(events.add);

      await driver.get(testPagePath);
    });

    tearDown(() async {
      sub.cancel();
      sub = null;
      events.clear();
      await driver.quit();
      driver = null;
    });

    test('handles exceptions', () async {
      var trace = new Trace.current(1);
      try {
        await driver.switchTo.alert;
      } catch (e) {}
      await waitFor(() => events, matcher: hasLength(2));
      expect(events[1].method, 'GET');
      expect(events[1].endPoint, contains('alert'));
      expect(events[1].exception, new isInstanceOf<WebDriverException>());
      expect(events[1].result, isNull);
      expect(events[1].startTime.isBefore(events[1].endTime), isTrue);
      compareTraces(events[1].stackTrace, trace);
    });

    test('handles normal operation', () async {
      var trace = new Trace.current(1);
      await driver.findElements(const By.cssSelector('nosuchelement')).toList();
      await waitFor(() => events, matcher: hasLength(2));
      expect(events[1].method, 'POST');
      expect(events[1].endPoint, contains('elements'));
      expect(events[1].exception, isNull);
      expect(events[1].result, hasLength(0));
      expect(events[1].startTime.isBefore(events[1].endTime), isTrue);
      compareTraces(events[1].stackTrace, trace);
    });
  }, testOn: '!js');
}

void compareTraces(Trace actual, Trace expected) {
  expect(actual.frames.length, greaterThanOrEqualTo(expected.frames.length));
  var index1 = actual.frames.length - 1;
  var index2 = expected.frames.length - 1;

  while (index2 >= 0) {
    expect(
        actual.frames[index1].toString(), expected.frames[index2].toString());
    index1--;
    index2--;
  }
}
