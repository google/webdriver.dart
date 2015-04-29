#!/bin/bash

# Copyright 2013 Google Inc. All Rights Reserved.

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Fast fail the script on failures.
set -e

# Verify that the libraries are error free.
dartanalyzer --fatal-warnings \
  lib/async_helpers.dart \
  lib/core.dart \
  lib/html.dart \
  lib/io.dart \
  test/async_helpers_test.dart \
  test/html_test.dart \
  test/io_test.dart

# run test/async_helpers_test.dart
pub run test test/async_helpers_test.dart -p vm
pub run test test/async_helpers_test.dart -p chrome

# Start chromedriver.
chromedriver --port=4444 --url-base=wd/hub &

# Run test/io_test.dart.
pub run test test/io_test.dart -p vm

# Run test/html_test.dart.
# does not work with chromedriver
# pub run test test/html_test.dart -p chrome
