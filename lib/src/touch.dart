part of webdriver;

class Touch extends _WebDriverBase implements Future {

  Future _future;

  Touch._(prefix, commandProcessor, [this._future])
      : super('$prefix/touch', commandProcessor) {
    if (_future == null) {
      _future = new Future.value();
    }
  }

  /**
   * Single tap on the touch enabled device.
   */
  Touch click(WebElement element) =>
      _createNext((_) => _post('click', element));

  /**
   * Finger down on the screen.
   */
  Touch down(Point point) =>
      _createNext((_) => _post('down', point));

  /**
   * Finger up on the screen.
   */
  Touch up(Point point) =>
      _createNext((_) => _post('up', point));

  /**
   * Finger move on the screen.
   */
  Touch move(Point point) =>
      _createNext((_) => _post('move', point));

  /**
   * Scroll on the touch screen using finger based motion events.
   *
   * If start is specified, will start scrolling from that location, otherwise
   * will start scrolling from an arbitrary location.
   */
  Touch scroll(int xOffset, int yOffset, [WebElement start]) {
    var json = { 'xoffset': xOffset.floor(), 'yoffset': yOffset.floor()};
    if (start is WebElement) {
      json['element'] = start._elementId;
    }
    return _createNext((_) => _post('scroll', json));
  }

  /**
   * Double tap on the touch screen using finger motion events.
   */
  Touch doubleClick(WebElement element) =>
      _createNext((_) => _post('doubleclick', element));

  /**
   * Long press on the touch screen using finger motion events.
   */
  Touch longClick(WebElement element) =>
      _createNext((_) => _post('longclick', element));

  /**
   * Flick on the touch screen using finger motion events.
   */
  Touch flickElement(WebElement start, int xOffset, int yOffset, int speed) =>
      _createNext((_) => _post('flick', {
        'element': start._elementId,
        'xoffset': xOffset.floor(),
        'yoffset': yOffset.floor(),
        'speed': speed.floor()
      }));

  /**
   * Flick on the touch screen using finger motion events.
   */
  Touch flick(int xSpeed, int ySpeed) =>
      _createNext((_) => _post('flick', {
        'xspeed': xSpeed.floor(),
        'yspeed': ySpeed.floor()
      }));

  Touch _createNext(f(value)) {
    return new Touch._(_prefix, _commandProcessor, _future.then(f));
  }

  Stream asStream() => _future.asStream();

  Future catchError(onError(error), {bool test(error)}) =>
      _future.catchError(onError, test: test);

  Future then(onValue(value), {onError(error)}) =>
      _future.then(onValue, onError: onError);

  Future whenComplete(action()) =>
      _future.whenComplete(action);

  Future timeout(Duration timeLimit, {onTimeout()}) =>
      _future.timeout(timeLimit, onTimeout: onTimeout);
}
