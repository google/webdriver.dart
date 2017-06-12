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

import 'command_event.dart';
import 'common.dart';
import 'exception.dart';
import 'target_locator.dart';
import 'timeouts.dart';
import 'web_element.dart';
import 'window.dart';

import 'common_spec/navigation.dart';
import 'common_spec/cookies.dart';

import 'json_wire_spec/mouse.dart';
import 'json_wire_spec/logs.dart';
import 'json_wire_spec/keyboard.dart';

typedef void WebDriverListener(WebDriverCommandEvent event);

/// Interacts with WebDriver.
abstract class WebDriver implements SearchContext {
  Map<String, dynamic> get capabilities;
  String get id;
  Uri get uri;
  bool get filterStackTraces;

  /// If true, WebDriver actions are recorded as [WebDriverCommandEvent]s.
  bool get notifyListeners;

  /// Preferred method for registering listeners. Listeners are expected to
  /// return a Future. Use new Future.value() for synchronous listeners.
  void addEventListener(WebDriverListener listener);

  /// The current url.
  String get currentUrl;

  /// navigate to the specified url
  void get(/* Uri | String */ url);

  /// The title of the current page.
  String get title;

  /// Search for multiple elements within the entire current page.
  @override
  List<WebElement> findElements(By by);

  /// Search for an element within the entire current page.
  /// Throws [NoSuchElementException] if a matching element is not found.
  @override
  WebElement findElement(By by);

  /// An artist's rendition of the current page's source.
  String get pageSource;

  /// Close the current window, quitting the browser if it is the last window.
  void close();

  /// Quit the browser.
  void quit({bool closeSession: true});

  /// Handles for all of the currently displayed tabs/windows.
  List<Window> get windows;

  /// Handle for the active tab/window.
  Window get window;

  /// The currently focused element, or the body element if no element has
  /// focus.
  WebElement get activeElement;

  Windows get windowsManager;

  TargetLocator get switchTo;

  Navigation get navigate;

  Cookies get cookies;

  @Deprecated('This not supported in the W3C spec.')
  Logs get logs;

  Timeouts get timeouts;

  // TODO(staats): add actions support.

  @Deprecated('This not supported in the W3C spec. Use actions instead.')
  Keyboard get keyboard;

  @Deprecated('This not supported in the W3C spec. Use actions instead.')
  Mouse get mouse;

  /// Take a screenshot of the current page as PNG and return it as
  /// base64-encoded string.
  String captureScreenshotAsBase64();

  /// Take a screenshot of the current page as PNG as list of uint8.
  List<int> captureScreenshotAsList();

  /// Inject a snippet of JavaScript into the page for execution in the context
  /// of the currently selected frame. The executed script is assumed to be
  /// asynchronous and must signal that is done by invoking the provided
  /// callback, which is always provided as the final argument to the function.
  /// The value to this callback will be returned to the client.
  ///
  /// Asynchronous script commands may not span page loads. If an unload event
  /// is fired while waiting for a script result, an error will be thrown.
  ///
  /// The script argument defines the script to execute in the form of a
  /// function body. The function will be invoked with the provided args array
  /// and the values may be accessed via the arguments object in the order
  /// specified. The final argument will always be a callback function that must
  /// be invoked to signal that the script has finished.
  ///
  /// Arguments may be any JSON-able object. WebElements will be converted to
  /// the corresponding DOM element. Likewise, any DOM Elements in the script
  /// result will be converted to WebElements.
  dynamic executeAsync(String script, List args);

  /// Inject a snippet of JavaScript into the page for execution in the context
  /// of the currently selected frame. The executed script is assumed to be
  /// synchronous and the result of evaluating the script is returned.
  ///
  /// The script argument defines the script to execute in the form of a
  /// function body. The value returned by that function will be returned to the
  /// client. The function will be invoked with the provided args array and the
  /// values may be accessed via the arguments object in the order specified.
  ///
  /// Arguments may be any JSON-able object. WebElements will be converted to
  /// the corresponding DOM element. Likewise, any DOM Elements in the script
  /// result will be converted to WebElements.
  dynamic execute(String script, List args);

  /// Performs post request on command to the WebDriver server.
  ///
  /// For use by supporting WebDriver packages.
  dynamic postRequest(String command, [params]);

  /// Performs get request on command to the WebDriver server.
  ///
  /// For use by supporting WebDriver packages.
  dynamic getRequest(String command);

  /// Performs delete request on command to the WebDriver server.
  ///
  /// For use by supporting WebDriver packages.
  dynamic deleteRequest(String command);

  @override
  WebDriver get driver;
}
