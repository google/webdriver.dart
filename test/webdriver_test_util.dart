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

import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math' show Point, Rectangle;

import 'package:matcher/matcher.dart';
import 'package:webdriver/async_core.dart' show WebDriver;
import 'package:webdriver/async_io.dart' as wdio;

final Matcher isWebElement = new isInstanceOf<wdio.WebElement>();
final Matcher isRectangle = new isInstanceOf<Rectangle<int>>();
final Matcher isPoint = new isInstanceOf<Point<int>>();

Future<WebDriver> createTestDriver(
    {Map<String, dynamic> additionalCapabilities}) {
  var address = Platform.environment['WEB_TEST_WEBDRIVER_SERVER'];
  if (!address.endsWith('/')) {
    address += '/';
  }
  var uri = Uri.parse(address);
  return wdio.createDriver(uri: uri, desired: additionalCapabilities);
}
