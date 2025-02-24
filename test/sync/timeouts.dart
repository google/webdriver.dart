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
library;

import 'package:test/test.dart';
import 'package:webdriver/sync_core.dart';

import '../configs/sync_io_config.dart' as config;

void runTests({WebDriverSpec spec = WebDriverSpec.Auto}) {
  group('TimeOuts', () {
    late WebDriver driver;

    setUp(() {
      driver = config.createTestDriver(spec: spec);
    });

    // TODO(DrMarcII): Figure out how to tell if timeouts are correctly set
    test('set all timeouts', () {
      driver.timeouts.setScriptTimeout(const Duration(seconds: 5));
      driver.timeouts.setImplicitTimeout(const Duration(seconds: 1));
      driver.timeouts.setPageLoadTimeout(const Duration(seconds: 10));
    });
  }, timeout: const Timeout(Duration(minutes: 2)));
}
