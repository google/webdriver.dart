part of webdriver;

class Touch implements Future {

  Future _future;
  final String _sessionId;
  final CommandProcessor _commandProcessor;

  Touch._(this._sessionId, this._commandProcessor, [this._future]) {
    if (_future == null) {
      _future = new Future.value();
    }
  }

  String get _prefix => '/session/$_sessionId/touch';

  /**
   * Single tap on the touch enabled device.
   */
  Touch click(WebElement element) => _createNext((_) =>
      _commandProcessor.post('$_prefix/click', element.json));

  /**
   * Finger down on the screen.
   */
  Touch down(Point point) => _createNext((_) =>
      _commandProcessor.post('$_prefix/down', point.json));

  /**
   * Finger up on the screen.
   */
  Touch up(Point point) => _createNext((_) =>
      _commandProcessor.post('$_prefix/up', point.json));

  /**
   * Finger move on the screen.
   */
  Touch move(Point point) => _createNext((_) =>
      _commandProcessor.post('$_prefix/move', point.json));

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
    return _createNext((_) => _commandProcessor.post('$_prefix/scroll', json));
  }

  /**
   * Double tap on the touch screen using finger motion events.
   */
  Touch doubleClick(WebElement element) => _createNext((_) =>
      _commandProcessor.post('$_prefix/doubleclick', element.json));

  /**
   * Long press on the touch screen using finger motion events.
   */
  Touch longClick(WebElement element) => _createNext((_) =>
      _commandProcessor.post('$_prefix/longclick', element.json));

  /**
   * Flick on the touch screen using finger motion events.
   */
  Touch flickElement(WebElement start, int xOffset, int yOffset, int speed) =>
      _createNext((_) => _commandProcessor.post('$_prefix/flick', {
        'element': start._elementId,
        'xoffset': xOffset.floor(),
        'yoffset': yOffset.floor(),
        'speed': speed.floor()
      }));

  /**
   * Flick on the touch screen using finger motion events.
   */
  Touch flick(int xSpeed, int ySpeed) =>
      _createNext((_) => _commandProcessor.post('$_prefix/flick', {
        'xspeed': xSpeed.floor(),
        'yspeed': ySpeed.floor()
      }));

  Touch _createNext(f) {
    return new Touch._(_sessionId, _commandProcessor, _future.then(f));
  }

  Stream asStream() => _future.asStream();

  Future catchError(onError, {test}) =>
      _future.catchError(onError, test: test);

  Future then(onValue, {onError}) =>
      _future.then(onValue, onError: onError);

  Future whenComplete(action) =>
      _future.whenComplete(action);
}
