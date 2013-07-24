part of webdriver;

class WebElement implements SearchContext {
  final String _elementId;
  final String _sessionId;
  final CommandProcessor _commandProcessor;

  WebElement._(this._elementId, this._sessionId, this._commandProcessor);

  String get _prefix => '/session/$_sessionId/element/$_elementId';

  /**
   * Click on this element.
   */
  Future click() => _commandProcessor.post('$_prefix/click');

  /**
   * Submit this element if it is part of a form.
   */
  Future submit() => _commandProcessor.post('$_prefix/submit');

  /**
   * Send keys to this element.
   */
  Future sendKeys(dynamic keysToSend) {
    if (keysToSend is String) {
      keysToSend = [ keysToSend ];
    }
    return _commandProcessor.post(
        '$_prefix/value',
        { 'value' : keysToSend as List<String>});
  }

  /**
   * Clear the content of a text element.
   */
  Future clear() => _commandProcessor.post('$_prefix/clear');

  /**
   * Is this radio button/checkbox selected?
   */
  Future<bool> get selected => _commandProcessor.get('$_prefix/selected');

  /**
   * Is this form element enabled?
   */
  Future<bool> get enabled => _commandProcessor.get('$_prefix/enabled');

  /**
   * Is this element visible in the page?
   */
  Future<bool> get displayed => _commandProcessor.get('$_prefix/displayed');

  /**
   * The location within the document of this element.
   */
  Future<Point> get location => _commandProcessor.get('$_prefix/location')
      .then((json) => new Point.fromJson(json));

  /**
   * The size of this element.
   */
  Future<Size> get size => _commandProcessor.get('$_prefix/size')
      .then((json) => new Size.fromJson(json));

  /**
   * The tag name for this element.
   */
  Future<String> get name => _commandProcessor.get('$_prefix/name');

  /**
   * Visible text within this element.
   */
  Future<String> get text => _commandProcessor.get('$_prefix/text');

  /**
   * Find an element nested within this element.
   *
   * @throws WebDriverError no such element if matching element is not found.
   */
  Future<WebElement> findElement(By by) =>
      _commandProcessor.post('$_prefix/element', by.json)
      .then((element) =>
          new WebElement._(element['ELEMENT'], _sessionId, _commandProcessor));

  /**
   * Find multiple elements nested within this element.
   */
  Future<List<WebElement>> findElements(By by) =>
      _commandProcessor.post('$_prefix/elements', by.json)
      .then((response) => response.map((element) =>
          new WebElement._(element['ELEMENT'], _sessionId, _commandProcessor)));

  /**
   * Access to the HTML attributes of this tag.
   */
  Attributes get attributes =>
      new Attributes._('$_prefix/attribute', _commandProcessor);

  /**
   * Access to the cssProperties of this element.
   */
  Attributes get cssProperties =>
      new Attributes._('$_prefix/css', _commandProcessor);

  /**
   * Does this element represent the same element as another element?
   * Not the same as ==
   */
  Future<bool> equals(WebElement other) =>
      _commandProcessor.get('$_prefix/equals/${other._elementId}');

  Map<String, String> get json => { 'ELEMENT': _elementId };

  @override
  bool operator ==(WebElement other) => _elementId == other._elementId &&
      _sessionId == other._sessionId &&
      _commandProcessor == other._commandProcessor;

  @override
  int get hashCode => _elementId.hashCode << 7 +
      _sessionId.hashCode << 3 + _commandProcessor.hashCode;
}
