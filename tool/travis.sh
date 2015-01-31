#!/bin/bash

# Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.

# Fast fail the script on failures.
set -e

# Verify that the libraries are error free.
dartanalyzer --fatal-warnings \
  lib/webdriver.dart \
  test/webdriver_test.dart

if [ "$TRAVIS" ]; then
  # Start chromedriver.
  chromedriver --port=4444 --url-base=wd/hub &
  
  # Run test/webdriver_test.dart.
  dart test/webdriver_test.dart
fi
