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
pub global activate tuneup
pub global run tuneup check

# Start chromedriver.
chromedriver --port=4444 --url-base=wd/hub &

# Run tests
# TODO(DrMarcII) enable running tests in browser when chrome setuid problem
# is fixed on travis.
pub run test:test -r expanded -p vm
pub run webdriver:test -r expanded -p chrome test/support/async_test.dart test/test/hybrid_test.dart
