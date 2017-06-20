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

import 'dart:convert' show BASE64;
import 'package:stack_trace/stack_trace.dart' show Chain;

import 'element_finder.dart';
import 'navigation.dart';
import 'target_locator.dart';
import 'timeouts.dart';
import 'web_element.dart';
import 'window.dart';

import '../common_spec/cookies.dart';

// We don't implement this, but we need the types to define the API.
import '../json_wire_spec/keyboard.dart';
import '../json_wire_spec/logs.dart';
import '../json_wire_spec/mouse.dart';

import '../command_event.dart';
import '../command_processor.dart';
import '../common.dart';
import '../navigation.dart';
import '../target_locator.dart';
import '../timeouts.dart';
import '../web_driver.dart';
import '../web_element.dart';
import '../window.dart';

class W3cWebDriver implements WebDriver, SearchContext {
  final CommandProcessor _commandProcessor;
  final Uri _prefix;
  final Map<String, dynamic> capabilities;
  final String id;
  final Uri uri;
  final bool filterStackTraces;
  ElementFinder _finder;

  @override
  bool notifyListeners = true;

  final _commandListeners = new List<WebDriverListener>();

  W3cWebDriver(this._commandProcessor, Uri uri, String id, this.capabilities,
      {this.filterStackTraces: true})
      : this.uri = uri,
        this.id = id,
        this._prefix = uri.resolve('session/$id/') {
    _finder = new ElementFinder(this, new Resolver(driver, ''), this);
  }

  @override
  void addEventListener(WebDriverListener listener) =>
      _commandListeners.add(listener);

  @override
  String get currentUrl => getRequest('url') as String;

  @override
  void get(/* Uri | String */ url) {
    final urlStr = (url is Uri) ? url.toString() : url;
    postRequest('url', {'url': urlStr as String});
  }

  @override
  String get title => getRequest('title') as String;

  @override
  List<WebElement> findElements(By by) => _finder.findElements(by);

  @override
  WebElement findElement(By by) => _finder.findElement(by);

  @override
  String get pageSource => getRequest('source') as String;

  @override
  void close() {
    deleteRequest('window');
  }

  @override
  void quit({bool closeSession: true}) {
    try {
      if (closeSession) {
        _commandProcessor.delete(uri.resolve('session/$id'));
      }
    } finally {
      _commandProcessor.close();
    }
  }

  @override
  List<Window> get windows => new W3cWindows(this).allWindows;

  @override
  Window get window => new W3cWindows(this).activeWindow;

  @override
  WebElement get activeElement => _finder.findActiveElement();

  @override
  Windows get windowsManager => new W3cWindows(this);

  @override
  TargetLocator get switchTo => new W3cTargetLocator(this);

  @override
  Navigation get navigate => new W3cNavigation(this);

  @override
  Cookies get cookies => new Cookies(this);

  @override
  Timeouts get timeouts => new W3cTimeouts(this);

  //TODO(staats): better exceptions. Also I should probably write an Action API.
  @override
  Logs get logs => throw 'Unsupported in W3C spec.';

  @override
  Keyboard get keyboard =>
      throw 'Unsupported in W3C spec, use Actions instead.';

  @override
  Mouse get mouse => throw 'Unsupported in W3C spec, use Actions instead.';

  @override
  String captureScreenshotAsBase64() => getRequest('screenshot');

  @override
  List<int> captureScreenshotAsList() {
    final base64Encoded = captureScreenshotAsBase64();
    return BASE64.decode(base64Encoded);
  }

  @override
  dynamic executeAsync(String script, List args) => _recursiveElementify(
      postRequest('execute/async', {'script': script, 'args': args}));

  @override
  dynamic execute(String script, List args) => _recursiveElementify(
      postRequest('execute/sync', {'script': script, 'args': args}));

  dynamic _recursiveElementify(result) {
    if (result is Map) {
      if (result.containsKey(jsonWireElementStr)) {
        return new W3cWebElement(
            this, result[jsonWireElementStr], this, 'javascript');
      } else {
        final newResult = {};
        result.forEach((key, value) {
          newResult[key] = _recursiveElementify(value);
        });
        return newResult;
      }
    } else if (result is List) {
      return result.map((value) => _recursiveElementify(value)).toList();
    } else {
      return result;
    }
  }

  @override
  dynamic postRequest(String command, [params]) => _performRequestWithLog(
      () => _commandProcessor.post(_resolve(command), params),
      'POST',
      command,
      params);

  @override
  dynamic getRequest(String command) => _performRequestWithLog(
      () => _commandProcessor.get(_resolve(command)), 'GET', command, null);

  @override
  dynamic deleteRequest(String command) => _performRequestWithLog(
      () => _commandProcessor.delete(_resolve(command)),
      'DELETE',
      command,
      null);

  // Performs request and sends the result to listeners/onCommandController.
  dynamic _performRequestWithLog(
      Function fn, String method, String command, params) {
    final startTime = new DateTime.now();
    var trace = new Chain.current();
    if (filterStackTraces) {
      trace = trace.foldFrames(
          (f) => f.library.startsWith('package:webdriver/'),
          terse: true);
    }
    var result;
    var exception;
    try {
      result = fn();
      return result;
    } catch (e) {
      exception = e;
      rethrow;
    } finally {
      if (notifyListeners) {
        for (WebDriverListener listener in _commandListeners) {
          listener(new WebDriverCommandEvent(
              method: method,
              endPoint: command,
              params: params,
              startTime: startTime,
              endTime: new DateTime.now(),
              exception: exception,
              result: result,
              stackTrace: trace));
        }
      }
    }
  }

  Uri _resolve(String command) {
    var uri = _prefix.resolve(command);
    if (uri.path.endsWith('/')) {
      uri = uri.replace(path: uri.path.substring(0, uri.path.length - 1));
    }
    return uri;
  }

  @override
  WebDriver get driver => this;

  @override
  String toString() => 'W3cWebDriver($_prefix)';
}
