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
import 'package:webdriver/src/sync/web_driver.dart' show WebDriver;

import 'package:webdriver/src/sync/command_processor.dart';
import 'package:webdriver/src/sync/spec_inference_response_processor.dart';
import 'package:webdriver/src/sync/json_wire_spec/response_processor.dart';
import 'package:webdriver/src/sync/json_wire_spec/web_driver.dart' as jwire;
import 'package:webdriver/src/sync/w3c_spec/response_processor.dart';
import 'package:webdriver/src/sync/w3c_spec/web_driver.dart' as w3c;

export 'package:webdriver/src/sync/alert.dart';
export 'package:webdriver/src/sync/capabilities.dart';
export 'package:webdriver/src/sync/command_event.dart';
export 'package:webdriver/src/sync/command_processor.dart';
export 'package:webdriver/src/sync/common.dart';
export 'package:webdriver/src/sync/common_spec/cookies.dart';
export 'package:webdriver/src/sync/keyboard.dart';
export 'package:webdriver/src/sync/navigation.dart';
export 'package:webdriver/src/sync/exception.dart';
export 'package:webdriver/src/sync/json_wire_spec/exception.dart';
export 'package:webdriver/src/sync/json_wire_spec/logs.dart';
export 'package:webdriver/src/sync/json_wire_spec/mouse.dart';
export 'package:webdriver/src/sync/timeouts.dart';
export 'package:webdriver/src/sync/target_locator.dart';
export 'package:webdriver/src/sync/web_driver.dart';
export 'package:webdriver/src/sync/web_element.dart';
export 'package:webdriver/src/sync/window.dart';

final Uri defaultUri = Uri.parse('http://127.0.0.1:4444/wd/hub/');

/// Defines the WebDriver spec to use. Auto = try to infer the spec based on
/// the response during session creation.
enum WebDriverSpec { Auto, JsonWire, W3c }

WebDriver createDriver(
    {Uri uri,
    Map<String, dynamic> desired,
    WebDriverSpec spec = WebDriverSpec.Auto}) {
  uri ??= defaultUri;

  desired ??= Capabilities.empty;

  switch (spec) {
    case WebDriverSpec.JsonWire:
      final processor =
          new SyncHttpCommandProcessor(processor: processJsonWireResponse);
      final response = processor.post(
          uri.resolve('session'), {'desiredCapabilities': desired},
          value: false) as Map<String, dynamic>;
      return new jwire.JsonWireWebDriver(processor, uri, response['sessionId'],
          new UnmodifiableMapView(response['value'] as Map<String, dynamic>));
    case WebDriverSpec.W3c:
      final processor =
          new SyncHttpCommandProcessor(processor: processW3cResponse);
      final response = processor.post(
          uri.resolve('session'),
          {
            'capabilities': {'desiredCapabilities': desired}
          },
          value: true) as Map<String, dynamic>;
      return new w3c.W3cWebDriver(processor, uri, response['sessionId'],
          new UnmodifiableMapView(response['value'] as Map<String, dynamic>));
    case WebDriverSpec.Auto:
      final response =
          new SyncHttpCommandProcessor(processor: inferSessionResponseSpec)
              .post(
                  uri.resolve('session'),
                  {
                    'desiredCapabilities': desired,
                    'capabilities': {'desiredCapabilities': desired}
                  },
                  value: true) as InferredResponse;
      return fromExistingSession(response.sessionId,
          uri: uri, spec: response.spec);
    default:
      throw 'Not yet supported!'; // Impossible.
  }
}

WebDriver fromExistingSession(String sessionId,
    {Uri uri, WebDriverSpec spec = WebDriverSpec.JsonWire}) {
  uri ??= defaultUri;

  switch (spec) {
    case WebDriverSpec.JsonWire:
      final processor =
          new SyncHttpCommandProcessor(processor: processJsonWireResponse);
      final response = processor.get(uri.resolve('session/$sessionId'))
          as Map<String, dynamic>;
      return new jwire.JsonWireWebDriver(
          processor, uri, sessionId, new UnmodifiableMapView(response));
    case WebDriverSpec.W3c:
      final processor =
          new SyncHttpCommandProcessor(processor: processW3cResponse);
      return new w3c.W3cWebDriver(
          processor, uri, sessionId, const <String, dynamic>{});
    case WebDriverSpec.Auto:
      throw 'Not supported!';
    default:
      throw 'Not yet supported!'; // Impossible.
  }
}
