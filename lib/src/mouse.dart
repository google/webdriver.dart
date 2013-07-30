part of webdriver;

class Mouse extends _WebDriverBase implements Future {

  static const int LEFT = 0;
  static const int MIDDLE = 1;
  static const int RIGHT = 2;

  Future _future;

  Mouse._(prefix, commandProcessor, [this._future]) :
      super(prefix, commandProcessor) {
    if (_future == null) {
      _future = new Future.value();
    }
  }

  /**
   * Click any mouse button (at the coordinates set by the last moveto command).
   */
  Mouse click([num button]) {
    var json = {};
    if (button is num) {
      json['button'] = button.clamp(0, 2).floor();
    }
    return _createNext((_) => _post('click', json));
  }

  /**
   * Click and hold any mouse button (at the coordinates set by the last
   * moveto command).
   */
  Mouse down([int button]) {
    var json = {};
    if (button is num) {
      json['button'] = button.clamp(0, 2).floor();
    }
    return _createNext((_) =>
        _post('buttondown', json));
  }

  /**
   * Releases the mouse button previously held (where the mouse is currently
   * at).
   */
  Mouse up([int button]) {
    var json = {};
    if (button is num) {
      json['button'] = button.clamp(0, 2).floor();
    }
    return _createNext((_) =>
        _post('buttonup', json));
  }

  /**
   * Double-clicks at the current mouse coordinates (set by moveto).
   */
  Mouse doubleClick() =>
      _createNext((_) => _post('doubleclick'));

  /**
   * Move the mouse.
   *
   * If element is specified and xOffset and yOffset are not, will move the
   * mouse to the center of the element.
   *
   * If xOffset and yOffset are specified, will move the mouse that distance
   * from its current location.
   *
   * If all three are specified, will move the mouse to the offset relative to
   * the top-left corner of the element.
   *
   * All other combinations of parameters are illegal.
   */

  Mouse moveTo({WebElement element, int xOffset, int yOffset}) {
    var json = {};
    if (element is WebElement) {
      json['element'] = element._elementId;
    }
    if (xOffset is num && yOffset is num) {
      json['xoffset'] = xOffset.floor();
      json['yoffset'] = yOffset.floor();
    }
    return _createNext((_) => _post('moveto', json));
  }

  Mouse _createNext(f) {
    return new Mouse._(_prefix, _commandProcessor, _future.then(f));
  }

  Stream asStream() => _future.asStream();

  Future catchError(onError, {test}) =>
      _future.catchError(onError, test: test);

  Future then(onValue, {onError}) =>
      _future.then(onValue, onError: onError);

  Future whenComplete(action) =>
      _future.whenComplete(action);
}