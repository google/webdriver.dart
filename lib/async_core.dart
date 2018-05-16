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

library webdriver.core;

import 'dart:async' show Future, Stream, StreamController;
import 'dart:collection' show UnmodifiableMapView;
import 'dart:convert' show base64;
import 'dart:math' show Point, Rectangle;

import 'package:stack_trace/stack_trace.dart' show Chain;

import 'package:webdriver/src/async/command_processor.dart'
    show CommandProcessor;
import 'package:webdriver/src/async/stepper.dart' show Stepper;

export 'package:webdriver/src/async/exception.dart';

part 'package:webdriver/src/async/alert.dart';
part 'package:webdriver/src/async/capabilities.dart';
part 'package:webdriver/src/async/command_event.dart';
part 'package:webdriver/src/async/common.dart';
part 'package:webdriver/src/async/keyboard.dart';
part 'package:webdriver/src/async/logs.dart';
part 'package:webdriver/src/async/mouse.dart';
part 'package:webdriver/src/async/navigation.dart';
part 'package:webdriver/src/async/options.dart';
part 'package:webdriver/src/async/target_locator.dart';
part 'package:webdriver/src/async/web_driver.dart';
part 'package:webdriver/src/async/web_element.dart';
part 'package:webdriver/src/async/window.dart';

final Uri defaultUri = Uri.parse('http://127.0.0.1:4444/wd/hub/');

Future<WebDriver> createDriver(CommandProcessor processor,
    {Uri uri, Map<String, dynamic> desired}) async {
  uri ??= defaultUri;

  desired ??= Capabilities.empty;

  Map<String, dynamic> response = new Map.from(await processor.post(
      uri.resolve('session'), {'desiredCapabilities': desired},
      value: false));
  return new WebDriver(processor, uri, response['sessionId'],
      new UnmodifiableMapView(response['value'] as Map<String, dynamic>));
}

Future<WebDriver> fromExistingSession(
    CommandProcessor processor, String sessionId,
    {Uri uri}) async {
  uri ??= defaultUri;

  Map<String, dynamic> response =
      new Map.from(await processor.get(uri.resolve('session/$sessionId')));
  return new WebDriver(
      processor, uri, sessionId, new UnmodifiableMapView(response));
}
