part of webdriver;

class WebDriver implements SearchContext {
  final _CommandProcessor _commandProcessor;
  final Uri _prefix;
  final Map<String, dynamic> capabilities;
  final String id;
  final Uri uri;

  WebDriver._(this._commandProcessor, Uri uri, String id, this.capabilities)
      : this.uri = uri,
        this.id = id,
        this._prefix = uri.resolve('session/$id/');

  /// Creates a WebDriver instance connected to the specified WebDriver server.
  static Future<WebDriver> createDriver(
      {Uri uri, Map<String, dynamic> desiredCapabilities}) async {
    if (uri == null) {
      uri = Uri.parse('http://127.0.0.1:4444/wd/hub/');
    }

    var commandProcessor = new _CommandProcessor();

    if (desiredCapabilities == null) {
      desiredCapabilities = Capabilities.empty;
    }

    var response = await commandProcessor.post(uri.resolve('session'), {
      'desiredCapabilities': desiredCapabilities
    }, value: false);
    return new WebDriver._(commandProcessor, uri, response['sessionId'],
        new UnmodifiableMapView(response['value']));
  }

  /// Navigate to the specified url.
  Future get(String url) async {
    await _post('url', {'url': url});
  }

  /// The current url.
  Future<String> get currentUrl => _get('url');

  /// The title of the current page.
  Future<String> get title => _get('title');

  /// Search for multiple elements within the entire current page.
  @override
  Stream<WebElement> findElements(By by) {
    var controller = new StreamController<WebElement>();

    () async {
      var elements = await _post('elements', by);
      int i = 0;
      for (var element in elements) {
        controller.add(new WebElement._(this, element['ELEMENT'], this, by, i));
        i++;
      }
      await controller.close();
    }();

    return controller.stream;
  }

// TODO(DrMarcII): switch to this when async* is supported
//   async* {
//    var elements = await _post('elements', by);
//    int i = 0;
//
//    for (var element in elements) {
//      yield new WebElement._(this, element['ELEMENT'], this, by, i);
//      i++;
//    }
//  }

  /**
   * Search for an element within the entire current page.
   *
   * Throws [WebDriverError] no such element if a matching element is not found.
   */
  Future<WebElement> findElement(By by) async {
    var element = await _post('element', by);
    return new WebElement._(this, element['ELEMENT'], this, by);
  }

  /// An artist's rendition of the current page's source.
  Future<String> get pageSource => _get('source');

  /// Close the current window, quitting the browser if it is the last window.
  Future close() async {
    await _delete('window');
  }

  /// Quit the browser.
  Future quit() async {
    await _commandProcessor.delete(uri.resolve('session/$id'));
  }

  /// Handles for all of the currently displayed tabs/windows.
  Stream<Window> get windows {
    var controller = new StreamController<Window>();

    () async {
      var handles = await _get('window_handles');
      int i = 0;
      for (var handle in handles) {
        controller.add(new Window._(this, handle));
        i++;
      }
      await controller.close();
    }();

    return controller.stream;
  }

// TODO(DrMarcII): switch to this when async* is supported
//  async* {
//    var handles = await _get('window_handles');
//
//    for (var handle in handles) {
//      yield new Window._(this, handle);
//    }
//  }

  /// Handle for the active tab/window.
  Future<Window> get window async {
    var handle = await _get('window_handle');
    return new Window._(this, handle);
  }

  /**
   *  The currently focused element, or the body element if no
   *  element has focus.
   */
  Future<WebElement> get activeElement async {
    var element = await _post('element/active');
    if (element != null) {
      return new WebElement._(this, element['ELEMENT'], this, 'activeElement');
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
  Future<List<int>> captureScreenshot() => _get('screenshot')
      .then((screenshot) => CryptoUtils.base64StringToBytes(screenshot));

  /**
   * Inject a snippet of JavaScript into the page for execution in the context
   * of the currently selected frame. The executed script is assumed to be
   * asynchronous and must signal that is done by invoking the provided
   * callback, which is always provided as the final argument to the function.
   * The value to this callback will be returned to the client.
   *
   * Asynchronous script commands may not span page loads. If an unload event
   * is fired while waiting for a script result, an error will be thrown.
   *
   * The script argument defines the script to execute in the form of a
   * function body. The function will be invoked with the provided args array
   * and the values may be accessed via the arguments object in the order
   * specified. The final argument will always be a callback function that must
   * be invoked to signal that the script has finished.
   *
   * Arguments may be any JSON-able object. WebElements will be converted to
   * the corresponding DOM element. Likewise, any DOM Elements in the script
   * result will be converted to WebElements.
   */
  Future executeAsync(String script, List args) => _post('execute_async', {
    'script': script,
    'args': args
  }).then(_recursiveElementify);

  /**
   * Inject a snippet of JavaScript into the page for execution in the context
   * of the currently selected frame. The executed script is assumed to be
   * synchronous and the result of evaluating the script is returned.
   *
   * The script argument defines the script to execute in the form of a
   * function body. The value returned by that function will be returned to the
   * client. The function will be invoked with the provided args array and the
   * values may be accessed via the arguments object in the order specified.
   *
   * Arguments may be any JSON-able object. WebElements will be converted to
   * the corresponding DOM element. Likewise, any DOM Elements in the script
   * result will be converted to WebElements.
   */
  Future execute(String script, List args) => _post(
      'execute', {'script': script, 'args': args}).then(_recursiveElementify);

  dynamic _recursiveElementify(result) {
    if (result is Map) {
      if (result.length == 1 && result.containsKey(_ELEMENT)) {
        return new WebElement._(this, result['ELEMENT'], this, 'javascript');
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

  Future _post(String command, [params]) =>
      _commandProcessor.post(_prefix.resolve(command), params);

  Future _get(String command) =>
      _commandProcessor.get(_prefix.resolve(command));

  Future _delete(String command) =>
      _commandProcessor.delete(_prefix.resolve(command));
}
