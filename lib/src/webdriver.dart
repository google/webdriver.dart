part of webdriver;

class WebDriver extends _WebDriverBase implements SearchContext {

  WebDriver._(commandProcessor) :
      super('', commandProcessor) ;

  /**
   * Creates a WebDriver instance connected to the specifier WebDriver server.
   */
  static Future<WebDriver> createDriver({
      String url: 'http://localhost:4444/wd/hub',
      Map<String, dynamic> desiredCapabilities}) {

    if (desiredCapabilities == null) {
      desiredCapabilities = Capabilities.empty;
    }
    var client = new HttpClient();
    return client.openUrl('POST', Uri.parse(url + "/session")).then((req) {
      req.followRedirects = false;
      req.headers.add(HttpHeaders.ACCEPT, "application/json");
      req.headers.add(HttpHeaders.CONTENT_TYPE, 'application/json;charset=UTF-8');
      req.write(json.stringify({
        'desiredCapabilities': desiredCapabilities
      }));
      return req.close();

    }).then((rsp) {
      CommandProcessor processor = new CommandProcessor
          ._fromUrl(rsp.headers.value(HttpHeaders.LOCATION));
      return new WebDriver._(processor);
    });
  }

  /**
   * Navigate to the specified url.
   */
  Future get(String url) => _post('url', {'url': url});

  /**
   * The current url.
   */
  Future<String> get currentUrl => _get('url');

  /**
   * The title of the current page.
   */
  Future<String> get title => _get('title');

  /**
   * Search for multiple elements within the entire current page.
   */
  @override
  Future<List<WebElement>> findElements(By by) => _commandProcessor
      .post('elements', by.json)
      .then((response) => response.map((element) =>
          new WebElement._(element['ELEMENT'], _prefix, _commandProcessor)));

  /**
   * Search for an element within the entire current page.
   *
   * Throws WebDriverError no such element if a matching element is not found.
   */
  Future<WebElement> findElement(By by) => _commandProcessor
      .post('element', by.json)
      .then((element) =>
          new WebElement._(element['ELEMENT'], _prefix, _commandProcessor));

  /**
   * An artist's rendition of the current page's source.
   */
  Future<String> get pageSource => _get('source');

  /**
   * Close the current window, quitting the browser if it is the last window.
   */
  Future close() => _delete('window');

  /**
   * Quit the browser.
   */
  Future quit() => _delete(_prefix);

  /**
   * Handles for all of the currently displayed tabs/windows.
   */
  Future<List<String>> get windowHandles =>
      _get('window_handles');

  /**
   * Handle for the active tab/window.
   */
  Future<String> get windowHandle =>
      _get('window_handle');

  /**
   * The currently focused element, or the body element if no element has focus.
   */
  Future<WebElement> get activeElement =>
      _get('element/active');

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
          new Window._(window, _prefix, _commandProcessor)));

  Future<List<int>> captureScreenshot() => _commandProcessor
      .get('screenshot')
      .then((screenshot) => CryptoUtils.base64StringToBytes(screenshot));
}