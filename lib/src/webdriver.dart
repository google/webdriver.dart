part of webdriver;

class WebDriver implements SearchContext {
  final String _sessionId;
  final CommandProcessor _commandProcessor;

  WebDriver._(this._sessionId, this._commandProcessor);

  /**
   * Creates a WebDriver instance connected to the specifier WebDriver server.
   */
  static Future<WebDriver> createDriver(String url) {
    var commandProcessor = new CommandProcessor._fromUrl(url);
    return commandProcessor.get('/session').then((sessionId) =>
        new WebDriver._(sessionId, commandProcessor));
  }

  String get _prefix => '/session/$_sessionId';

  /**
   * Navigate to the specified url.
   */
  Future get(String url) =>
      _commandProcessor.post('$_prefix/url', {'url': url});

  /**
   * The current url.
   */
  Future<String> get currentUrl => _commandProcessor.get('$_prefix/url');

  /**
   * The title of the current page.
   */
  Future<String> get title => _commandProcessor.get('$_prefix/title');

  /**
   * Search for multiple elements within the entire current page.
   */
  @override
  Future<List<WebElement>> findElements(By by) => _commandProcessor
      .post('$_prefix/elements', by.json)
      .then((response) => response.map((element) =>
          new WebElement._(element['ELEMENT'], _sessionId, _commandProcessor)));

  /**
   * Search for an element within the entire current page.
   *
   * @throws WebDriverError no such element if a matching element is not found.
   */
  Future<WebElement> findElement(By by) => _commandProcessor
      .post('$_prefix/element', by.json)
      .then((element) =>
          new WebElement._(element['ELEMENT'], _sessionId, _commandProcessor));

  /**
   * An artist's rendition of the current page's source.
   */
  Future<String> get pageSource => _commandProcessor.get('$_prefix/source');

  /**
   * Close the current window, quitting the browser if it is the last window.
   */
  Future close() => _commandProcessor.delete('$_prefix/window');

  /**
   * Quit the browser.
   */
  Future quit() => _commandProcessor.delete(_prefix);

  /**
   * Handles for all of the currently displayed tabs/windows.
   */
  Future<List<String>> get windowHandles =>
      _commandProcessor.get('$_prefix/window_handles');

  /**
   * Handle for the active tab/window.
   */
  Future<String> get windowHandle =>
      _commandProcessor.get('$_prefix/window_handle');

  /**
   * The currently focused element, or the body element if no element has focus.
   */
  Future<WebElement> get activeElement =>
      _commandProcessor.get('$_prefix/element/active');

  TargetLocator get switchTo =>
      new TargetLocator._(_sessionId, _commandProcessor);

  Navigation get navigate => new Navigation._(_sessionId, _commandProcessor);

  Cookies get cookies => new Cookies._(_sessionId, _commandProcessor);

  Timeouts get timeouts => new Timeouts._(_sessionId, _commandProcessor);

  Keyboard get keyboard => new Keyboard._(_sessionId, _commandProcessor);

  Mouse get mouse => new Mouse._(_sessionId, _commandProcessor);

  Touch get touch => new Touch._(_sessionId, _commandProcessor);

  Window get window =>
      new Window._(_sessionId, _commandProcessor, 'current');

  Future<List<Window>> get windows => windowHandles
      .then((windows) => windows.map((window) =>
          new Window._(_sessionId, _commandProcessor, window)));

  Future<List<int>> captureScreenshot() => _commandProcessor
      .get('$_prefix/screenshot')
      .then((screenshot) => CryptoUtils.base64StringToBytes(screenshot));
}