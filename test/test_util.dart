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

library webdriver_test_util;

import 'dart:io' show FileSystemEntity;
import 'package:path/path.dart' as path;

export 'webdriver_test_util.dart' show isWebElement, isRectangle, isPoint, createTestDriver;

String get testPagePath {
  String testPagePath = runfile(path.join('test', 'test_page.html'));
  if (!FileSystemEntity.isFileSync(testPagePath)) {
    throw new Exception('Could not find the test file at "$testPagePath".'
        ' Make sure you are running tests from the root of the project.');
  }
  return path.toUri(testPagePath).toString();
}

String runfile(String p) => path.absolute(p);