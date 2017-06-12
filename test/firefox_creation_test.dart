// Copyright 2017 Google Inc. All Rights Reserved.
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

import 'package:test/test.dart';

import 'sync/sync_io_config.dart' as config;

void main() {
  group('Firefox creation ', () {
    test('fails as expected', () {
      try {
        final driver = config.createFirefoxTestDriver();
        fail('Still using JSON wire spec, should not parse correctly.');
      } catch (e) {
        // Expected.
      }
    });
  }, timeout: new Timeout(new Duration(minutes: 1)));
}
