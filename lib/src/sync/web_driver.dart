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

part of webdriver.sync_core;

typedef void WebDriverListener(WebDriverCommandEvent event);

class WebDriver implements SearchContext {
  final CommandProcessor _commandProcessor;
  final Uri _prefix;
  final Map<String, dynamic> capabilities;
  final String id;
  final Uri uri;
  final bool filterStackTraces;

  /// If true, WebDriver actions are recorded as [WebDriverCommandEvent]s.
  bool notifyListeners = true;


  final _commandListeners = new List<WebDriverListener>();

  WebDriver(this._commandProcessor, Uri uri, String id, this.capabilities,
      {this.filterStackTraces: true})
      : this.uri = uri,
        this.id = id,
        this._prefix = uri.resolve('session/$id/');

  /// Preferred method for registering listeners. Listeners are expected to
  /// return a Future. Use new Future.value() for synchronous listeners.
  void addEventListener(WebDriverListener listener) =>
      _commandListeners.add(listener);

  /// The current url.
  String get currentUrl => getRequest('url') as String;

  /// navigate to the specified url
  void get(/* Uri | String */ url) {
    if (url is Uri) {
      url = url.toString();
    }
    postRequest('url', {'url': url as String});
  }

  /// The title of the current page.
  String get title => getRequest('title') as String;

  /// Search for multiple elements within the entire current page.
  @override
  List<WebElement> findElements(By by) {
    var elements = postRequest('elements', by);
    int i = 0;

    final webElements = new List<WebElement>();
    for (var element in elements) {
      webElements.add(new WebElement._(this, element[_element], this, by, i++));
    }
    return webElements;
  }

  /// Search for an element within the entire current page.
  /// Throws [NoSuchElementException] if a matching element is not found.
  @override
  WebElement findElement(By by) {
    var element = postRequest('element', by);
    return new WebElement._(this, element[_element], this, by);
  }

  /// An artist's rendition of the current page's source.
  String get pageSource => getRequest('source') as String;

  /// Close the current window, quitting the browser if it is the last window.
  void close() {
    deleteRequest('window');
  }

  /// Quit the browser.
  void quit({bool closeSession: true}) {
    try {
      if (closeSession) {
        _commandProcessor.delete(uri.resolve('session/$id'));
      }
    } finally {
      _commandProcessor.close();
    }
  }

  /// Handles for all of the currently displayed tabs/windows.
  List<Window> get windows {
    var handles = getRequest('window_handles') as List<String>;
    return handles.map((h) => new Window._(this, h)).toList();
  }

  /// Handle for the active tab/window.
  Window get window {
    var handle = getRequest('window_handle');
    return new Window._(this, handle);
  }

  /// The currently focused element, or the body element if no element has
  /// focus.
  WebElement get activeElement {
    var element = postRequest('element/active');
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

  /// Take a screenshot of the current page as PNG and return it as
  /// base64-encoded string.
  String captureScreenshotAsBase64() =>
      getRequest('screenshot');

  /// Take a screenshot of the current page as PNG as list of uint8.
  List<int> captureScreenshotAsList() {
    var base64Encoded = captureScreenshotAsBase64();
    return BASE64.decode(base64Encoded);
  }

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
  dynamic executeAsync(String script, List args) =>
      _recursiveElementify(postRequest('execute_async', {'script': script, 'args': args}));

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
  dynamic execute(String script, List args) =>
      _recursiveElementify(postRequest('execute', {'script': script, 'args': args}));

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

  dynamic postRequest(String command, [params]) => _performRequestWithLog(
      () => _commandProcessor.post(_resolve(command), params),
      'POST',
      command,
      params);

  dynamic getRequest(String command) => _performRequestWithLog(
      () => _commandProcessor.get(_resolve(command)), 'GET', command, null);

  dynamic deleteRequest(String command) => _performRequestWithLog(
      () => _commandProcessor.delete(_resolve(command)),
      'DELETE',
      command,
      null);

  // Performs request and sends the result to listeners/onCommandController.
  // This is typically always what you want to use.
  void _performRequestWithLog(
      Function fn, String method, String command, params) {
    final result =  _performRequest(fn, method, command, params);
    if (notifyListeners) {
      if (_previousEvent == null) {
        throw new Error(); // This should be impossible.
      }
      for (WebDriverListener listener in _commandListeners) {
        listener(_previousEvent);
      }
    }
  }

  // This is an ugly hack, I know, but I dunno how to cleanly do this.
  var _previousEvent = null;

  // Performs the request. This will not notify any listeners or
  // onCommandController. This should only be called from
  // _performRequestWithLog.
  void _performRequest(
      Function fn, String method, String command, params) {
    var startTime = new DateTime.now();
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
  String toString() => 'WebDriver($_prefix)';
}
