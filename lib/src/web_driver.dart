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

part of webdriver.core;

class WebDriver implements SearchContext {
  final CommandProcessor _commandProcessor;
  final Uri _prefix;
  final Map<String, dynamic> capabilities;
  final String id;
  final Uri uri;

  WebDriver(this._commandProcessor, Uri uri, String id, this.capabilities)
      : this.uri = uri,
        this.id = id,
        this._prefix = uri.resolve('session/$id/');

  /// The current url.
  Future<String> get currentUrl => get('url');

  /// The title of the current page.
  Future<String> get title => get('title');

  /// Search for multiple elements within the entire current page.
  @override
  Stream<WebElement> findElements(By by) async* {
    var elements = await post('elements', by);
    int i = 0;

    for (var element in elements) {
      yield new WebElement._(this, element[_element], this, by, i);
      i++;
    }
  }

  /// Search for an element within the entire current page.
  /// Throws [NoSuchElementException] if a matching element is not found.
  @override
  Future<WebElement> findElement(By by) async {
    var element = await post('element', by);
    return new WebElement._(this, element[_element], this, by);
  }

  /// An artist's rendition of the current page's source.
  Future<String> get pageSource => get('source');

  /// Close the current window, quitting the browser if it is the last window.
  Future close() async {
    await delete('window');
  }

  /// Quit the browser.
  Future quit() async {
    await _commandProcessor.delete(uri.resolve('session/$id'));
  }

  /// Handles for all of the currently displayed tabs/windows.
  Stream<Window> get windows async* {
    var handles = await get('window_handles');

    for (var handle in handles) {
      yield new Window._(this, handle);
    }
  }

  /// Handle for the active tab/window.
  Future<Window> get window async {
    var handle = await get('window_handle');
    return new Window._(this, handle);
  }

  /// The currently focused element, or the body element if no element has
  /// focus.
  Future<WebElement> get activeElement async {
    var element = await post('element/active');
    if (element != null) {
      return new WebElement._(this, element[_element], this, 'activeElement');
    }
    return null;
  }

  TargetLocator get switchTo => new TargetLocator._(this);

  Navigation get navigate => new Navigation._(this);

  Cookies get cookies => new Cookies._(this);

  Logs get logs => new Logs._(this);

  Timeouts get timeouts => new Timeouts._(this);

  Keyboard get keyboard => new Keyboard._(this);

  Mouse get mouse => new Mouse._(this);

  /// Take a screenshot of the current page as PNG.
  Future<List<int>> captureScreenshot() => get('screenshot')
      .then((screenshot) => CryptoUtils.base64StringToBytes(screenshot));

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
  Future executeAsync(String script, List args) => post(
          'execute_async', {'script': script, 'args': args})
      .then(_recursiveElementify);

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
  Future execute(String script, List args) => post(
      'execute', {'script': script, 'args': args}).then(_recursiveElementify);

  dynamic _recursiveElementify(result) {
    if (result is Map) {
      if (result.length == 1 && result.containsKey(_element)) {
        return new WebElement._(this, result[_element], this, 'javascript');
      } else {
        var newResult = {};
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

  Future post(String command, [params]) =>
      _commandProcessor.post(_prefix.resolve(command), params);

  Future get(String command) => _commandProcessor.get(_prefix.resolve(command));

  Future delete(String command) =>
      _commandProcessor.delete(_prefix.resolve(command));

  @override
  WebDriver get driver => this;

  @override
  String toString() => 'WebDriver($_prefix)';
}
