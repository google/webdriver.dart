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

library webdriver.sync_core;

import 'dart:collection' show UnmodifiableMapView;
import 'dart:convert' show BASE64;
import 'dart:math' show Point, Rectangle;

import 'package:stack_trace/stack_trace.dart' show Chain;

import 'package:webdriver/src/sync/command_processor.dart' show CommandProcessor;

export 'package:webdriver/src/sync/exception.dart';

part 'package:webdriver/src/sync/alert.dart';
part 'package:webdriver/src/sync/capabilities.dart';
part 'package:webdriver/src/sync/command_event.dart';
part 'package:webdriver/src/sync/common.dart';
part 'package:webdriver/src/sync/keyboard.dart';
part 'package:webdriver/src/sync/logs.dart';
part 'package:webdriver/src/sync/mouse.dart';
part 'package:webdriver/src/sync/navigation.dart';
part 'package:webdriver/src/sync/options.dart';
part 'package:webdriver/src/sync/target_locator.dart';
part 'package:webdriver/src/sync/web_driver.dart';
part 'package:webdriver/src/sync/web_element.dart';
part 'package:webdriver/src/sync/window.dart';

final Uri defaultUri = Uri.parse('http://127.0.0.1:4444/wd/hub/');

WebDriver createDriver(CommandProcessor processor,
    {Uri uri, Map<String, dynamic> desired})  {
  if (uri == null) {
    uri = defaultUri;
  }

  if (desired == null) {
    desired = Capabilities.empty;
  }

  Map response = processor.post(
      uri.resolve('session'), {'desiredCapabilities': desired},
      value: false) as Map<String, dynamic>;
  return new WebDriver(processor, uri, response['sessionId'],
      new UnmodifiableMapView(response['value'] as Map<String, dynamic>));
}

WebDriver fromExistingSession(
    CommandProcessor processor, String sessionId,
    {Uri uri}) {
  if (uri == null) {
    uri = defaultUri;
  }

  var response = processor.get(uri.resolve('session/$sessionId'))
      as Map<String, dynamic>;
  return new WebDriver(
      processor, uri, sessionId, new UnmodifiableMapView(response));
}
