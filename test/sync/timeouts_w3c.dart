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
library webdriver.options_test;

import 'package:test/test.dart';
import 'package:webdriver/src/common/timeouts.dart';
import 'package:webdriver/sync_core.dart';

import '../configs/sync_io_config.dart' as config;

void runTests({WebDriverSpec spec = WebDriverSpec.Auto}) {
  group('TimeOuts', () {
    late WebDriver driver;

    setUp(() {
      driver = config.createTestDriver(spec: spec);
    });

    test('set all timeouts', () {
      const five = Duration(seconds: 5);
      const one = Duration(seconds: 1);
      const ten = Duration(seconds: 10);

      driver.timeouts.setScriptTimeout(five);
      driver.timeouts.setImplicitTimeout(one);
      driver.timeouts.setPageLoadTimeout(ten);

      expect(driver.timeouts.getAllTimeouts(),
          TimeoutValues(script: five, implicit: one, pageLoad: ten));
    });

    test('get default timeouts', () {
      expect(
          driver.timeouts.getAllTimeouts(),
          TimeoutValues(
              script: const Duration(seconds: 30),
              implicit: Duration.zero,
              pageLoad: const Duration(minutes: 5)));
    });
  }, timeout: const Timeout(Duration(minutes: 2)));
}
