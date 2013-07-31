part of webdriver;

/**
 * Simple class to provide access to index properties such as WebElement
 * attributes or css styles.
 */
class Attributes extends _WebDriverBase{

  Attributes._(command, prefix, commandProcessor)
    : super('$prefix/$command', commandProcessor);

  Future<String> operator [](String name) => _get(name);
}

class Size {
  final num height;
  final num width;

  const Size(this.height, this.width);

  Size.fromJson(Map json) : this(json['height'], json['width']);

  Map<String, num> toJson() => {
    'height': height,
    'width': width
  };
}

class Point {
  final num x;
  final num y;

  const Point(this.x, this.y);

  Point.fromJson(Map json) : this(json['x'], json['y']);

  Map<String, num> toJson() => {
    'x': x,
    'y': y
  };
}

abstract class SearchContext {

  /**
   * Searches for multiple elements within the context.
   */
  Future<List<WebElement>> findElements(By by);

  /**
   * Searchs for an element within the context.
   *
   * Throws WebDriverError no such element exception if no matching element is
   * found.
   */
  Future<WebElement> findElement(By by);
}

abstract class _WebDriverBase {
  final String _prefix;
  final CommandProcessor _commandProcessor;

  _WebDriverBase(this._prefix, this._commandProcessor);

  Future _post(String command, [param]) =>
      _commandProcessor.post(_command(command), param);

  Future _get(String command) => _commandProcessor.get(_command(command));

  Future _delete(String command) => _commandProcessor.delete(_command(command));

  String _command(String command) {
    if (command == null || command.isEmpty) {
      return _prefix;
    } else if (_prefix == null || _prefix.isEmpty) {
      return '$command';
    } else {
      return '$_prefix/$command';
    }
  }
}

class By {
  final String _using;
  final String _value;

  const By._(this._using, this._value);

  /**
   * Returns an element whose ID attribute matches the search value.
   */
  const By.id(String id) : this._('id', id);

  /**
   * Returns an element matching an XPath expression.
   */
  const By.xpath(String xpath) : this._('xpath', xpath);

  /**
   * Returns an anchor element whose visible text matches the search value.
   */
  const By.linkText(String linkText) : this._('link text', linkText);

  /**
   * Returns an anchor element whose visible text partially matches the search
   * value.
   */
  const By.partialLinkText(String partialLinkText) :
      this._('partial link text', partialLinkText);

  /**
   * Returns an element whose NAME attribute matches the search value.
   */
  const By.name(String name) : this._('name', name);

  /**
   * Returns an element whose tag name matches the search value.
   */
  const By.tagName(String tagName) : this._('tag name', tagName);

  /**
   * Returns an element whose class name contains the search value; compound
   * class names are not permitted
   */
  const By.className(String className) : this._('class name', className);

  /**
   * Returns an element matching a CSS selector.
   */
  const By.cssSelector(String cssSelector) :
      this._('css selector', cssSelector);

  Map<String, String> toJson() => { 'using': _using, 'value': _value};
}

// TODO(DrMarcII): Create a better WebDriver exception hierarchy.
class WebDriverError {
  static const List<String> _errorTypes = const [
      null,
      'IndexOutOfBounds',
      'NoCollection',
      'NoString',
      'NoStringLength',
      'NoStringWrapper',
      'NoSuchDriver',
      'NoSuchElement',
      'NoSuchFrame',
      'UnknownCommand',
      'ObsoleteElement',
      'ElementNotDisplayed',
      'InvalidElementState',
      'Unhandled',
      'Expected',
      'ElementNotSelectable',
      'NoSuchDocument',
      'UnexpectedJavascript',
      'NoScriptResult',
      'XPathLookup',
      'NoSuchCollection',
      'TimeOut',
      'NullPointer',
      'NoSuchWindow',
      'InvalidCookieDomain',
      'UnableToSetCookie',
      'UnexpectedAlertOpen',
      'NoAlertOpen',
      'ScriptTimeout',
      'InvalidElementCoordinates',
      'IMENotAvailable',
      'IMEEngineActivationFailed',
      'InvalidSelector',
      'SessionNotCreatedException',
      'MoveTargetOutOfBounds'];
  static const List<String> _errorDetails = const [
      null,
      'IndexOutOfBounds',
      'NoCollection',
      'NoString',
      'NoStringLength',
      'NoStringWrapper',
      'NoSuchDriver',
      'An element could not be located on the page using the given '
      'search parameters.',
      'A request to switch to a frame could not be satisfied because the '
      'frame could not be found.',
      'The requested resource could not be found, or a request was '
      'received using an HTTP method that is not supported by the '
      'mapped resource.',
      'An element command failed because the referenced element is no '
      'longer attached to the DOM.',
      'An element command could not be completed because the element '
      'is not visible on the page.',
      'An element command could not be completed because the element is in '
      'an invalid state (e.g. attempting to click a disabled element).',
      'An unknown server-side error occurred while processing the command.',
      'Expected',
      'An attempt was made to select an element that cannot be selected.',
      'NoSuchDocument',
      'An error occurred while executing user supplied JavaScript.',
      'NoScriptResult',
      'An error occurred while searching for an element by XPath.',
      'NoSuchCollection',
      'An operation did not complete before its timeout expired.',
      'NullPointer',
      'A request to switch to a different window could not be satisfied '
      'because the window could not be found.',
      'An illegal attempt was made to set a cookie under a different '
      'domain than the current page.',
      'A request to set a cookie\'s value could not be satisfied.',
      'A modal dialog was open, blocking this operation.',
      'An attempt was made to operate on a modal dialog when one was '
      'not open.',
      'A script did not complete before its timeout expired.',
      'The coordinates provided to an interactions operation are invalid.',
      'IME was not available.',
      'An IME engine could not be started.',
      'Argument was an invalid selector (e.g. XPath/CSS).',
      'A new session could not be created.',
      'Target provided for a move action is out of bounds.'
      ];

  final int statusCode;
  String type;
  final String message;
  String details;
  final String results;

  WebDriverError(this.statusCode, this.message, [this.results = '']) {

    if (statusCode < 0 || statusCode > 32) {
      type = 'External';
      details = '';
    } else {
      type = _errorTypes[statusCode];
      details = _errorDetails[statusCode];
    }
  }

  String toString() {
    return '$statusCode $type: $message $results\n$details';
  }
}