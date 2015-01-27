part of webdriver;

class WebDriver extends _WebDriverBase implements SearchContext {

  WebDriver._(commandProcessor) : super('', commandProcessor) ;

  /// Creates a WebDriver instance connected to the specified WebDriver server.
  static Future<WebDriver> createDriver({
      String url: 'http://localhost:4444/wd/hub',
      Map<String, dynamic> desiredCapabilities}) {

    if (desiredCapabilities == null) {
      desiredCapabilities = Capabilities.empty;
    }
    var client = new HttpClient();
    var requestUri = Uri.parse(url + "/session");
    return client.openUrl('POST', requestUri).then((req) {
      req.followRedirects = false;
      req.headers.add(HttpHeaders.ACCEPT, "application/json");
      req.headers.contentType = _CONTENT_TYPE_JSON;
      var body = UTF8.encode(
          JSON.encode({'desiredCapabilities': desiredCapabilities}));
      req.contentLength = body.length;
      req.add(body);
      return req.close();

    }).then((rsp) {
      // Starting in Selenium 2.34.0, the post/redirect/get pattern is no
      // longer used when creating a new session.
      if (300 <= rsp.statusCode && rsp.statusCode <= 399) {
        return Uri.parse(rsp.headers.value(HttpHeaders.LOCATION));
      }

      return rsp.transform(new Utf8Decoder())
          .fold(new StringBuffer(), (buffer, data) => buffer..write(data))
          .then((StringBuffer buffer) {
            // Strip NULs that WebDriver seems to include in some responses.
            var results = buffer.toString()
                .replaceAll(new RegExp('\u{0}*\$'), '');

            var status = 0;

            // 4xx responses send plain text; others send JSON
            if (HttpStatus.BAD_REQUEST <= rsp.statusCode
                && rsp.statusCode < HttpStatus.INTERNAL_SERVER_ERROR) {
              status = 13;  // UnknownError
              if (rsp.statusCode == HttpStatus.NOT_FOUND) {
                status = 9; // UnkownCommand
              }
              throw new WebDriverError(status, results);
            }

            var respObj = JSON.decode(results);
            status = respObj['status'];
            if (status != 0) {
              var value = respObj['value'];
              var message =
                  value.containsKey('message') ? value['message'] : null;
              throw new WebDriverError(status, message);
            }

            return Uri.parse(url + '/session/' + respObj['sessionId']);
          });
    }).then((sessionUrl) {
      var host = sessionUrl.host;
      var port = sessionUrl.port;
      if (host.isEmpty) {
        host = requestUri.host;
        if (port == 0) {
          port = requestUri.port;
        }
      }
      CommandProcessor processor = new CommandProcessor(
          host, port, sessionUrl.path);
      return new WebDriver._(processor);
    });
  }

  /// Navigate to the specified url.
  Future<WebDriver> get(String url) =>
      _post('url', {'url': url}).then((_) => this);

  /// The current url.
  Future<String> get currentUrl => _get('url');

  /// The title of the current page.
  Future<String> get title => _get('title');

  /// Search for multiple elements within the entire current page.
  @override
  Future<List<WebElement>> findElements(By by) => _post('elements', by)
      .then((response) =>
          response.map((element) =>
              new WebElement._(element, _prefix, _commandProcessor))
              .toList());

  /**
   * Search for an element within the entire current page.
   *
   * Throws [WebDriverError] no such element if a matching element is not found.
   */
  Future<WebElement> findElement(By by) => _post('element', by)
      .then((element) =>
          new WebElement._(element, _prefix, _commandProcessor));

  /// An artist's rendition of the current page's source.
  Future<String> get pageSource => _get('source');

  /// Close the current window, quitting the browser if it is the last window.
  Future close() => _delete('window');

  /// Quit the browser.
  Future quit() => _delete(_prefix);

  /// Handles for all of the currently displayed tabs/windows.
  Future<List<String>> get windowHandles => _get('window_handles');

  /// Handle for the active tab/window.
  Future<String> get windowHandle => _get('window_handle');

  /**
   *  The currently focused element, or the body element if no
   *  element has focus.
   */
  Future<WebElement> get activeElement => _get('element/active')
      .then((element) {
        if (element == null) {
          return null;
        } else {
          new WebElement._(element['ELEMENT'], _prefix, _commandProcessor);
        }
      });

  TargetLocator get switchTo =>
      new TargetLocator._(_prefix, _commandProcessor);

  Navigation get navigate => new Navigation._(_prefix, _commandProcessor);

  Cookies get cookies => new Cookies._(_prefix, _commandProcessor);

  Timeouts get timeouts => new Timeouts._(_prefix, _commandProcessor);

  Keyboard get keyboard => new Keyboard._(_prefix, _commandProcessor);

  Mouse get mouse => new Mouse._(_prefix, _commandProcessor);

  Touch get touch => new Touch._(_prefix, _commandProcessor);

  Window get window =>
      new Window._( 'current', _prefix, _commandProcessor);

  Future<List<Window>> get windows => windowHandles
      .then((windows) => windows.map((window) =>
          new Window._(window, _prefix, _commandProcessor)).toList());

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
  Future executeAsync(String script, List args) =>
      _post('execute_async', {
        'script': script,
        'args': args
      })
      .then(_recursiveElementify);

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
  Future execute(String script, List args) =>
      _post('execute', {
        'script': script,
        'args': args
      })
      .then(_recursiveElementify);

  dynamic _recursiveElementify(result) {
    if (result is Map) {
      if (result.length == 1 && result.containsKey(_ELEMENT)) {
        return new WebElement._(result, _prefix, _commandProcessor);
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
}
