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

import 'package:webdriver/src/sync/capabilities.dart' show Capabilities;
import 'package:webdriver/src/sync/command_processor.dart'
    show CommandProcessor;
import 'package:webdriver/src/sync/web_driver.dart' show WebDriver;
import 'package:webdriver/src/sync/json_wire_spec/web_driver.dart' as jwire;

export 'package:webdriver/src/sync/alert.dart';
export 'package:webdriver/src/sync/capabilities.dart';
export 'package:webdriver/src/sync/command_event.dart';
export 'package:webdriver/src/sync/command_processor.dart';
export 'package:webdriver/src/sync/common.dart';
export 'package:webdriver/src/sync/common_spec/cookies.dart';
export 'package:webdriver/src/sync/common_spec/navigation.dart';
export 'package:webdriver/src/sync/exception.dart';
export 'package:webdriver/src/sync/json_wire_spec/keyboard.dart';
export 'package:webdriver/src/sync/json_wire_spec/logs.dart';
export 'package:webdriver/src/sync/json_wire_spec/mouse.dart';
export 'package:webdriver/src/sync/timeouts.dart';
export 'package:webdriver/src/sync/target_locator.dart';
export 'package:webdriver/src/sync/web_driver.dart';
export 'package:webdriver/src/sync/web_element.dart';
export 'package:webdriver/src/sync/window.dart';

final Uri defaultUri = Uri.parse('http://127.0.0.1:4444/wd/hub/');

//TODO(staats): when W3C spec created, infer spec during WebDriver creation.

WebDriver createDriver(CommandProcessor processor,
    {Uri uri, Map<String, dynamic> desired}) {
  if (uri == null) {
    uri = defaultUri;
  }

  if (desired == null) {
    desired = Capabilities.empty;
  }

  Map response = processor.post(
      uri.resolve('session'), {'desiredCapabilities': desired},
      value: false) as Map<String, dynamic>;
  return new jwire.JsonWireWebDriver(processor, uri, response['sessionId'],
      new UnmodifiableMapView(response['value'] as Map<String, dynamic>));
}

WebDriver fromExistingSession(CommandProcessor processor, String sessionId,
    {Uri uri}) {
  if (uri == null) {
    uri = defaultUri;
  }

  var response =
      processor.get(uri.resolve('session/$sessionId')) as Map<String, dynamic>;
  return new jwire.JsonWireWebDriver(
      processor, uri, sessionId, new UnmodifiableMapView(response));
}
