part of webdriver;

class WebElement extends _WebDriverBase implements SearchContext {
  final String id;

  // These fields represent information about how the element was found.
  final SearchContext context;
  final dynamic /* String | By */ locator;
  final int index;

  WebElement._(driver, id, [this.context, this.locator, this.index])
      : this.id = id,
        super(driver, 'element/$id');

  /// Click on this element.
  Future click() async {
    await _post('click');
  }

  /// Submit this element if it is part of a form.
  Future submit() async {
    await _post('submit');
  }

  /// Send [keysToSend] to this element.
  Future sendKeys(String keysToSend) async {
    await _post('value', { 'value' : [ keysToSend ]});
  }

  /// Clear the content of a text element.
  Future clear() async {
    await _post('clear');
  }

  /// Is this radio button/checkbox selected?
  Future<bool> get selected => _get('selected');

  /// Is this form element enabled?
  Future<bool> get enabled => _get('enabled');

  /// Is this element visible in the page?
  Future<bool> get displayed => _get('displayed');

  /// The location within the document of this element.
  Future<Point> get location async {
    var point = await _get('location');
    return new Point.fromJson(point);
  }

  /// The size of this element.
  Future<Size> get size async {
    var size = await _get('size');
    return new Size.fromJson(size);
  }

  /// The tag name for this element.
  Future<String> get name => _get('name');

  ///  Visible text within this element.
  Future<String> get text => _get('text');

  /**
   * Find an element nested within this element.
   *
   * Throws [WebDriverError] no such element if matching element is not found.
   */
  Future<WebElement> findElement(By by) async {
    var element = await _post('element', by);
    return new WebElement._(driver, element['ELEMENT'], this, by);
  }

  /// Find multiple elements nested within this element.
  Stream<WebElement> findElements(By by) async* {
    var elements = await _post('elements', by);
    int i = 0;
    for (var element in elements) {
      yield new WebElement._(driver, element['ELEMENT'], this, by, i);
      i++;
    }
  }

  /**
   * Access to the HTML attributes of this tag.
   *
   * TODO(DrMarcII): consider special handling of boolean attributes.
   */
  Attributes get attributes =>
      new Attributes._(driver, '$_prefix/attribute');

  /**
   * Access to the cssProperties of this element.
   *
   * TODO(DrMarcII): consider special handling of color and possibly other
   *                 properties.
   */
  Attributes get cssProperties =>
      new Attributes._(driver, '$_prefix/css');

  /**
   * Does this element represent the same element as another element?
   * Not the same as ==
   */
  Future<bool> equals(WebElement other) => _get('equals/${other.id}');

  Map<String, String> toJson() => {'ELEMENT': id};
}
