part of webdriver;

class WebElement extends _WebDriverBase implements SearchContext {
  String _elementId;
  String _originalPrefix;

  WebElement._(elementId, prefix, commandProcessor) :
      super('$prefix/element/$elementId', commandProcessor) {
    this._elementId = elementId;
    this._originalPrefix = prefix;
  }

  /**
   * Click on this element.
   */
  Future click() => _post('click');

  /**
   * Submit this element if it is part of a form.
   */
  Future submit() => _post('submit');

  /**
   * Send keys to this element.
   *
   * @param keysToSend a String or List<String>.
   */
  Future sendKeys(dynamic keysToSend) {
    if (keysToSend is String) {
      keysToSend = [ keysToSend ];
    }
    return _post('value', { 'value' : keysToSend as List<String>});
  }

  /**
   * Clear the content of a text element.
   */
  Future clear() => _post('clear');

  /**
   * Is this radio button/checkbox selected?
   */
  Future<bool> get selected => _get('selected');

  /**
   * Is this form element enabled?
   */
  Future<bool> get enabled => _get('enabled');

  /**
   * Is this element visible in the page?
   */
  Future<bool> get displayed => _get('displayed');

  /**
   * The location within the document of this element.
   */
  Future<Point> get location => _get('location')
      .then((json) => new Point.fromJson(json));

  /**
   * The size of this element.
   */
  Future<Size> get size => _get('size')
      .then((json) => new Size.fromJson(json));

  /**
   * The tag name for this element.
   */
  Future<String> get name => _get('name');

  /**
   * Visible text within this element.
   */
  Future<String> get text => _get('text');

  /**
   * Find an element nested within this element.
   *
   * Throws WebDriverError no such element if matching element is not found.
   */
  Future<WebElement> findElement(By by) => _post('element', by.json)
      .then((element) =>
          new WebElement._(element['ELEMENT'], _originalPrefix,
              _commandProcessor));

  /**
   * Find multiple elements nested within this element.
   */
  Future<List<WebElement>> findElements(By by) => _post('elements', by.json)
      .then((response) => response.map((element) =>
          new WebElement._(element['ELEMENT'], _originalPrefix,
              _commandProcessor)).toList());

  /**
   * Access to the HTML attributes of this tag.
   *
   * TODO(DrMarcII): consider special handling of boolean attributes.
   */
  Attributes get attributes =>
      new Attributes._('attribute', _prefix, _commandProcessor);

  /**
   * Access to the cssProperties of this element.
   *
   * TODO(DrMarcII): consider special handling of color and possibly other
   *                 properties.
   */
  Attributes get cssProperties =>
      new Attributes._('css', _prefix, _commandProcessor);

  /**
   * Does this element represent the same element as another element?
   * Not the same as ==
   */
  Future<bool> equals(WebElement other) =>
      _get('equals/${other._elementId}');

  Map<String, String> get json => { 'ELEMENT': _elementId };
}
